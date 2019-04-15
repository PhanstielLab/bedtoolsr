import os
import datetime
import time
import re
import argparse
import shutil
from collections import OrderedDict
import json

FUNCTION_PREFIX = "bt."

#-------------------------------- Functions -------------------------------#

# Define a function that captures all of the information below a header until next1 or next2
def captureFxnInfo(bedtoolsFxn, bedtoolspath, bedtoolsRpath):

    print(bedtoolsFxn)

    helpcmdsfilename = os.path.join(bedtoolsRpath, bedtoolsFxn + ".txt")
    os.system(os.path.join(bedtoolspath, "bedtools") + " " + bedtoolsFxn + " -h &> " + helpcmdsfilename)
    helpcmdsfile = open(helpcmdsfilename, "r")
    help = helpcmdsfile.read()
    helpcmdsfile.close()
    os.remove(helpcmdsfilename)

    infoDict = OrderedDict()
    infoDict["ToolName"] = bedtoolsFxn
    match = re.search("Tool:\s+(.+)", help)
    infoDict["Tool"] = match.groups()[0]
    match = re.search("Summary:\s+(.+?)\n\n", help, re.DOTALL)
    infoDict["Summary"] = match.groups()[0].replace("\t", "").replace("         ", "").replace("\n ", "\n") + "\n"

    if(bedtoolsFxn in anomalies["alternativeUsage"]):
        match = re.search("(.+)", anomalies["alternativeUsage"][bedtoolsFxn], re.DOTALL)
    else:
        match = re.search("Usage:(.+)", help, re.DOTALL)
    if(match is None):
        print("WARNING: " + bedtoolsFxn + " could not be created because usage is not defined.")
        usageDict = None
    else:
        usage = ""
        for line in match.groups()[0].split("\n"):
            if(line.strip() == "" or line.startswith("Options:")):
                break
            usage += "\n  " + line.lstrip()
        usage = re.sub("[\\[].*?[\\]] ?", "", usage)
        infoDict["Usage"] = usage
        usageArray = usage.split(" -")
        usageDict = OrderedDict()
        for x in range(1, len(usageArray)):
            usageWord = "".join(usageArray[x].split(" ")[0])
            usageDefinition = " ".join(usageArray[x].split(" ")[1:])
            usageDict[usageWord.rstrip()] = usageDefinition.rstrip()

    optionDict = OrderedDict()
    match = re.search("Options:(.+)", help, re.DOTALL)
    if(match is not None):
        option = ""
        description = ""
        for line in match.groups()[0].split("\n"):
            if(line.startswith("\t-")):
                if(option != "" and description != ""):
                    optionDict[option] = description + "\n"
                match = re.search("-(\S+) ?\S*\s+(.*)", line)
                if(match is None):
                    match = re.search("-(\S+)", line)
                option = match.groups()[0]
                if('|' in option):
                    option = option[:option.index('|')]
                if(len(match.groups()) > 1):
                    description = match.groups()[1].replace("\t", "")
                else:
                    description = ""
            elif(line.startswith("\t\t\t")):
                description += "\n    " + line[3:].replace("\t", " ")
            elif(line.startswith("\t\t")):
                description += "\n  " + line[2:].replace("\t", " ")
            elif(not line.startswith("\t")):
                if(option != "" and description != ""):
                    optionDict[option] = description + "\n"
                if(not "Options:" in line and not line.strip() == ""):
                    break
        if(option != "" and description != ""):
            optionDict[option] = description + "\n"
        if(bedtoolsFxn in anomalies["ignoreOptions"]):
            for i in anomalies["ignoreOptions"][bedtoolsFxn]:
                if i in optionDict:
                    del optionDict[i]

    if(usageDict is not None):
        newUsageDict = usageDict.copy()
        for i in usageDict:
            if(not any(x in usageDict[i] for x in anomalies["fileOptions"])):
                optionDict[i] = usageDict[i]
                del newUsageDict[i]
            elif(i in optionDict):
                del optionDict[i]
        usageDict = newUsageDict

    return(infoDict, usageDict, optionDict)

### Define a function that write R functions 
def writeRfxn(infoDict, usageDict, optionDict, bedtoolsRpath):

    command = infoDict["ToolName"]

    # Determine if the header of the output file should be read
    readheader = "FALSE"
    if command in anomalies["hasHeader"]:
        readheader = "TRUE"

    # Determine if the R object inputs are allowed
    allowRobjectsInput = "TRUE"
    if command in anomalies["noRinput"]:
        allowRobjectsInput = "FALSE"

    comment = "#' "

    file = open(os.path.join(bedtoolsRpath, "R", "%s.R" % (FUNCTION_PREFIX + command)), "w")

    summarySplit = infoDict["Summary"].split("\n")

    for line in summarySplit:
        file.write(comment + line)
        file.write("\n")

    for key in usageDict:
        usageLines =  "@param " + key + " " + usageDict[key].replace("%", " percent")
        usageSplit = usageLines.split("\n")
        for line in usageSplit:
            file.write(comment + line + "\n")

    # Convert to R friendly options
    for option in optionDict:
        roption = option
        if option in anomalies["optionConverter"].keys():
            roption = anomalies["optionConverter"][option]
        optionLines = "@param " + roption + " " + optionDict[option].replace("%", " percent")
        optionSplit = optionLines.split("\n")
        for line in optionSplit:
            file.write(comment + line + "\n")

    if(not command in anomalies["noRoutput"]):
        file.write(comment + "@param output Output filepath instead of returning output in R.\n")
        file.write(comment + "\n")

    setOptions= ""
    for option in optionDict:
        roption = option
        if option in anomalies["optionConverter"].keys():
            roption = anomalies["optionConverter"][option]
        setOptions += roption + " = NULL, "
    if(not command in anomalies["noRoutput"]):
        setOptions += "output = NULL"
    else:
        setOptions = setOptions[:-2]

    usageDictOptions = ""

    for key in usageDict:
        usageDictOptions += key + (" = NULL, " if bedtoolsFxn in anomalies["allowNullEvenIfFile"] and key in anomalies["allowNullEvenIfFile"][bedtoolsFxn] else ", ")
    if(len(setOptions) == 0):
        usageDictOptions = usageDictOptions[:-2]
    file.write(FUNCTION_PREFIX + infoDict["ToolName"] + " <- " + "function(" + usageDictOptions + setOptions + ")\n")
    file.write("{\n")

    # Establish the file paths and write temp files
    file.write("\t# Required Inputs\n")
    for key in usageDict:
        file.write("\t")
        file.write("""%s <- establishPaths(input=%s, name="%s", allowRobjects=%s)""" % (key, key, key, allowRobjectsInput))
        file.write("\n")
    file.write("\n")
    file.write('\toptions <- ""\n')
    file.write("\n")

    # Establish the options
    file.write("\t# Options\n")
    optionsbedtools = list()
    optionsr = list()
    for option in optionDict:
        roption = option
        if option in anomalies["optionConverter"].keys():
            roption = anomalies["optionConverter"][option]
        optionsbedtools.append("\"" + option + "\"")
        optionsr.append(roption)
    optionsbedtoolscombined = ", ".join(optionsbedtools)
    optionsrcombined = ", ".join(optionsr)
    file.write("\t")
    file.write("""options <- createOptions(names=c(%s), values=list(%s))""" % (optionsbedtoolscombined, optionsrcombined))      
    file.write("\n")

    # Launch the bedtools command
    file.write('\n\t# establish output file \n')
    file.write('\ttempfile <- tempfile("bedtoolsr", fileext=".txt")\n' )
    cmdstring = ""
    for key in usageDict:
        if(command in anomalies["allowNullEvenIfFile"] and key in anomalies["allowNullEvenIfFile"][command]):
            cmdstring += ', ifelse(!is.null(%s), paste0(" -%s ", %s[[1]]), "")' % (key, key, key)
        else:
            cmdstring += ', " -%s ", %s[[1]]' % (key, key)

    file.write('\tbedtools.path <- getOption(\"bedtools.path\")\n')
    file.write('\tif(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, \"/\")\n')
    file.write('\tcmd <- paste0(bedtools.path, "bedtools ' + infoDict["ToolName"].rstrip() + ' ", options' + cmdstring)
    if(command in anomalies["noRoutput"]):
        file.write(")\n\tconsole.output <- system(cmd, intern=TRUE)\n\tprint(console.output)\n")
    else:
        file.write(', " > ", tempfile)\n')
        file.write('\tsystem(cmd)\n')
        file.write('\tif(!is.null(output)) {\n')
        file.write('\t\tif(file.info(tempfile)$size > 0)\n')
        file.write('\t\t\tfile.copy(tempfile, output)\n')
        file.write('\t} else {\n')
        file.write('\t\tif(file.info(tempfile)$size > 0)\n')
        file.write('\t\t\tresults <- utils::read.table(tempfile, header=%s, sep="\\t")\n' % readheader)
        file.write('\t\telse\n')
        file.write('\t\t\tresults <- data.frame()\n')
        file.write('\t}\n')

    # Delete the temp files
    file.write('\n\t# Delete temp files\n')
    tempfiles = list()
    tempfiles.append("tempfile")
    for key in usageDict:
        tempfiles.append(key + "[[2]]")
    filestodelete = ", ".join(tempfiles)
    file.write("""\tdeleteTempFiles(c(%s))""" % filestodelete)

    # Return the results
    if(not command in anomalies["noRoutput"]):
        file.write('\n\n\tif(is.null(output))\n')
        file.write("\t\treturn(results)")
    file.write("\n}")

### Define a function that reads in bedtools functions
def readbedtoolsfxns(bedtoolspath, bedtoolsRpath):
    
    os.system(os.path.join(bedtoolspath, "bedtools") + " &> " + os.path.join(bedtoolsRpath, "bedtools.txt"))
    bedtoolsoutput = open(os.path.join(bedtoolsRpath, "bedtools.txt"), "r")
    fxnset = []
    version = ""
    for line in bedtoolsoutput:
        words = line.split(" ")
        if(line[:4] == '    ' and line[4] != '-' and words[4] not in anomalies["skipFunctions"]):
            fxnset.append(words[4])
        if(words[0] == "Version:"):
            version = words[-1].rstrip()
    os.remove(os.path.join(bedtoolsRpath, "bedtools.txt"))
    return(fxnset, version)

#-------------------------------- Main Code -------------------------------#

parser = argparse.ArgumentParser()
parser.add_argument("-B", "--bedtools", help="path to your bedtools", default="")
parser.add_argument("-O", "--output", help="directory to write package to", default=os.path.dirname(os.path.dirname(os.path.realpath(__file__))))
parser.add_argument("-V", "--version", help="version number of package", default="1")
args = parser.parse_args()

bedtoolspath = os.path.expanduser(args.bedtools)
bedtoolsRpath = os.path.expanduser(args.output)
versionsuffix = int(args.version)

print("Reading in anomalies...")
with open(os.path.join(os.path.dirname(os.path.realpath(__file__)), "anomalies.json"), "r") as anomaliesfile:
    anomalies = json.load(anomaliesfile)

print("Creating directories...")
if not os.path.exists(bedtoolsRpath):
    os.makedirs(bedtoolsRpath)
if not os.path.exists(os.path.join(bedtoolsRpath, "man")):
    os.makedirs(os.path.join(bedtoolsRpath, "man"))
if not os.path.exists(os.path.join(bedtoolsRpath, "R")):
    os.makedirs(os.path.join(bedtoolsRpath, "R"))
if not os.path.exists(os.path.join(bedtoolsRpath, "dev")):
    os.makedirs(os.path.join(bedtoolsRpath, "dev"))

print("Reading in all bedtools functions...")
bedtoolsFxns, version = readbedtoolsfxns(bedtoolspath, bedtoolsRpath)

print("Writing bedtoolsr function...")
validbedtoolsFxns = []
for bedtoolsFxn in bedtoolsFxns:
        infoDict, usageDict, optionDict = captureFxnInfo(bedtoolsFxn, bedtoolspath, bedtoolsRpath)
        if(infoDict is None or usageDict is None or optionDict is None):
            continue
        writeRfxn (infoDict, usageDict, optionDict, bedtoolsRpath)
        validbedtoolsFxns.append(bedtoolsFxn)

print("Writing DESCRIPTION file...")
with open(os.path.join(bedtoolsRpath, "DESCRIPTION"), "w") as descriptionfile:
    descriptionfile.write("Package: bedtoolsr\n")
    descriptionfile.write("Encoding: UTF-8\n")
    descriptionfile.write("Type: Package\n")
    descriptionfile.write("Title: Bedtools Wrapper\n")
    descriptionfile.write("Version: %s-%d\n" % (version[1:], versionsuffix))
    descriptionfile.write("Date: "+ str(datetime.date.today()) + "\n")
    descriptionfile.write("Author: Mayura Patwardhan, Craig Wenger, Doug Phanstiel\n")
    descriptionfile.write("Maintainer: Doug Phanstiel <douglas_phanstiel@med.unc.edu>\n")
    descriptionfile.write("Description: The purpose of my project is to write an R package that allows seamless use of bedtools from within the R environment. To accomplish this, I will write a python script that reads in the bedtools code and writes the entire R package.  By generating the code in this fashion, we can ensure that our package can easily be generated for all current and future versions of bedtools.\n")
    descriptionfile.write("Imports:\n")
    descriptionfile.write("    utils\n")
    descriptionfile.write("Suggests:\n")
    descriptionfile.write("    testthat\n")
    descriptionfile.write("License: MIT\n")

print("Writing NAMESPACE file...")
with open(os.path.join(bedtoolsRpath, "NAMESPACE"), "w") as namespacefile:
    namespacefile.write("export(" + ", ".join([FUNCTION_PREFIX + s for s in validbedtoolsFxns]) + ")\n")

print("Copying helper functions...")

# Functino to handle initialization
shutil.copy2(os.path.join(os.path.dirname(os.path.realpath(__file__)), "zzz.R"), os.path.join(bedtoolsRpath, "R"))

# Function to create options
shutil.copy2(os.path.join(os.path.dirname(os.path.realpath(__file__)), "createOptions.R"), os.path.join(bedtoolsRpath, "R"))

# Function to make and record temp files
shutil.copy2(os.path.join(os.path.dirname(os.path.realpath(__file__)), "establishPaths.R"), os.path.join(bedtoolsRpath, "R"))

# Function to delete temp files
shutil.copy2(os.path.join(os.path.dirname(os.path.realpath(__file__)), "deleteTempFiles.R"), os.path.join(bedtoolsRpath, "R"))

# Copy tests to inst
print("Copying tests...")
if(os.path.exists(os.path.join(bedtoolsRpath, "inst", "tests"))):
    shutil.rmtree(os.path.join(bedtoolsRpath, "inst", "tests"))
shutil.copytree(os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "tests"), os.path.join(bedtoolsRpath, "inst", "tests"))

# Copy tests to new tests dir
origtestpath = os.path.join(os.path.dirname(os.path.dirname(os.path.realpath(__file__))), "tests")
newtestpath  = os.path.join(bedtoolsRpath, "tests")
if (origtestpath != newtestpath):
	if(os.path.exists(newtestpath)):
		shutil.rmtree(newtestpath)
	shutil.copytree(origtestpath, newtestpath)

# Create documentation
print("Writing documentation...")
os.system("Rscript \"" + os.path.join(os.path.dirname(os.path.realpath(__file__)), "document.R") + "\" \"" + bedtoolsRpath + "\"")

print("Done!")
