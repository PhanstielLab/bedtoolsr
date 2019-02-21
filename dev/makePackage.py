import os 
import datetime
import time
import re
# define dictionaries

#functionList has all of the bedtools functions 
functionList = []

#optionDict has all of the bedtools options and their definitions
optionDict = {}

#infoDict has all of the headers of that function and their immediate definition
infoDict = {}


#usageDict has the required parameters of the function as the word and the format as the definition.
#Ex: usageWord = a, usageDefinition =<bed/gff/vcf/bam>

#usageDict required parameters are recognized by a "-" in front of name in the "Usage" section of bedtools help menu


usageDict = {}
version = ""
createR = 1
now = datetime.datetime.now()
fileinput=""
currentoption = ""




#captures all the commands in main bedtools menu
def captureCommands():
    global version
    text_file2.seek(0)
    for line in text_file2:
        words = line.split(" ")
        if(line[:4] == '    ' and line[4] != '-'):
            text_file3.write(words[4]+"\n")
        if(words[0] == "Version:"):
            version = words[-1].rstrip()




#captures all of the information below a header until next1 or next2
def capture(header, header1):
    global createR
    

    #start at the beginning of text file
    text_file.seek(0)


    #split each line by a space
    for line in text_file:
        words = line.split(" ")

        firstWord = words[0]
        

        #add to word and definition
        if(firstWord == header or firstWord == header1):
            definition = ""
            word = header[:-1]
            definition = (" ").join(words[1:]).lstrip()
            break                   

    #print none if the header does not exist
    if(firstWord != header and firstWord != header1):   
        createR = 0
        text_file4.write(currentoption.rstrip() + " could not be created because " + header[:-1] + " did not exist\n")
        return
    

    #print the lines before the next header
    for line in text_file:
        read = line.split(" ")
        if (len(read[0])>0): 
            if(read[0][-1] == ":" or (read[0][-2:] == ":\t") or (read[0][-2:] == ":\n")):
                break
        definition = definition + line.lstrip()
        if (header != "Summary:"):
            break


    #add word to dictionary                 
    infoDict[word] = definition 
    if(header == "Usage:"):
        infoDict["Usage"] = re.sub("[\\[].*?[\\]]", "", infoDict["Usage"])


def basic() :


    capture("Tool:", "Tool:\n")
    infoDict["ToolName"] = infoDict["Tool"].split(" ")[1].rstrip()
    capture("Summary:", "Summary\n")
    capture("Usage:", "Usage:\t")
    


def options():

    text_file.seek(0)
    for line in text_file:
        firstWord = line.split(" ")[0]  

        if(firstWord == "Options:" or firstWord == "Options:\n"):

            break
    
    
    if(firstWord != "Options:" and firstWord != "Options:\n"):  
        return

    
    for line in text_file:
        
        
        #option lines starts at the option menu and is an array of word separated by a tab
        read = line.split("\t")
        
        
        ## if the first word is Notes we have reached the end of the option menu and must break
        if(read[0] != "\n" and len(read)==1):
            break
        
        #if the line is not blank and line has a word on the second element of the array
        elif(len(read)>1 and len(read[1])>0):
            #definition will be the element right after the word element. add to dictionary
            #word element does not include dash
            if(read[1][0] == '-'):
                #reading the next nonempty string in the line as the definition
                definition = (" ").join(read[2:])               
                word = read[1][1:]
                #word can only be one word long
                word = word.split(" ")[0]
                optionDict[word] = definition
        
#if the line is not blank but does not have a word on the second element it is a continuation
#of the previous definition
        elif(len(read)>1):
            partialdef = (" ").join(read[2:])           
            definition = definition + partialdef            
            optionDict[word] = definition       
    



def bedtoolsFunction(command):


    
    UsageArray = infoDict["Usage"].split("-")
    for x in range (1, len(UsageArray)):
        usageWord = "".join(UsageArray[x].split(" ")[0])
        usageDefinition = " ".join(UsageArray[x].split(" ")[1:])
    
        usageDict[usageWord.rstrip()] = usageDefinition.rstrip()
    
    

    for i in usageDict:
        if i in optionDict:
            del optionDict[i]

    comment = "#' "
    
    file = open(fileinput + "/R/%s.r" % command, "w")

    summarySplit = infoDict["Summary"].split("\n")

    for line in summarySplit:
        file.write(comment + line)
        file.write("\n")

    for key in usageDict:
        usageLines =  "@param " + key + " " + usageDict[key].replace("%", " percent")
        usageSplit = usageLines.split("\n")
        for line in usageSplit:
            file.write(comment + line)
            file.write("\n")

    for option in optionDict:
      roption = option
      if(option == "3"):
            roption = "three"
      elif(option == "5"):
            roption = "five"
      elif(option == "name+"):
            roption = "nameplus"

      optionLines = "@param " + roption + " " + optionDict[option].replace("%", " percent")
      optionSplit = optionLines.split("\n")
      for line in optionSplit:
            file.write(comment + line)
            file.write("\n")

    setOptions= ""
    for option in optionDict:
      roption = option
      if(option == "3"):
            roption = "three"
      elif(option == "5"):
            roption = "five"
      elif(option == "name+"):
            roption = "nameplus"
      setOptions = setOptions + roption + " = " + "NULL" + ", "
    setOptions = setOptions[:-2]

    usageDictOptions = ""

    for key in usageDict:
        usageDictOptions = usageDictOptions + key + ", "
    if (len(setOptions) == 0):
        usageDictOptions = usageDictOptions[:-2]
    file.write(infoDict["ToolName"] + " <- " + "function(" + usageDictOptions  + setOptions + ")\n")
    file.write ("{ \n")
    
    # Establish the file paths and write temp files
    file.write("\t# Required Inputs\n")
    for key in usageDict:
      file.write ("\t")
      file.write("""%s = establishPaths(input=%s,name="%s")""" % (key,key,key))
      file.write ("\n")
    file.write ("\n")
    file.write('\toptions = "" \n' )
    file.write ("\n")

    # Establish the options
    file.write("\t# Options\n")
    optionsbedtools = list()
    optionsr = list()
    for option in optionDict:
      roption = option
      if(option == "3"):
            roption = "three"
      elif(option == "5"):
            roption = "five"
      elif(option == "name+"):
            roption = "nameplus"
      optionsbedtools.append("\"" + option + "\"")
      optionsr.append(roption)     
    optionsbedtoolscombined = ",".join(optionsbedtools)
    optionsrcombined = ",".join(optionsr)
    file.write ("\t")
    file.write("""options = createOptions(names = c(%s),values= list(%s))""" % (optionsbedtoolscombined,optionsrcombined))      
    file.write ("\n")
    
    
    # Launch the bedtools command
    file.write('\n\t# establish output file \n')
    file.write('\ttempfile = tempfile("bedtoolsr", fileext=".txt")\n' )
    cmdstring = ""
    for key in usageDict:
        cmdstring = cmdstring + ', " -%s ", %s[[1]]' % (key, key)

    file.write('\tbedtools.path <- getOption(\"bedtools.path\")\n')
    file.write('\tif(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, \"/\")\n')
    file.write('\tcmd = paste0(bedtools.path, "bedtools ' + infoDict["ToolName"].rstrip() + ' ", options' + cmdstring + ', " > ", tempfile) \n\tsystem(cmd) \n')
    file.write('\tresults = read.table(tempfile,header=FALSE,sep="\\t")')
    
    # Delete the temp files
    file.write('\n\n\t# Delete temp files \n')
    tempfiles = list()
    tempfiles.append("tempfile")
    for key in usageDict:
        tempfiles.append(key + "[[2]]")
    filestodelete = ",".join(tempfiles)
    file.write ("\t")
    file.write("""deleteTempfiles(c(%s))""" % filestodelete)
    
    # Return the results
    file.write("\n\treturn (results)\n}")
    
while True: 
    fileinput = input("Where would you like to make your R package? ").rstrip()
    fileinput = os.path.expanduser(fileinput)
    if not fileinput:
        continue
    if(os.path.isdir(fileinput) == False):
        print("This is not a valid path")
        continue
    else:
        break

bedtoolsinput = input("What is the bedtools path? ")
if(bedtoolsinput == ""):
    bedtoolsinputmain = "bedtools"
else:
    bedtoolsinput = os.path.expanduser(bedtoolsinput)
    bedtoolsinputmain = bedtoolsinput + "/bedtools"

while True:
    versionsuffixinput = input("What version suffix do you want added? ")
    try:
        versionsuffix = int(versionsuffixinput)
    except ValueError:
        print("Please enter an integer.")
    else:
        break

os.system("%s &> %s/bedtools.txt" % (bedtoolsinputmain, fileinput))
text_file2 = open(fileinput + "/bedtools.txt", "r")
text_file3 = open(fileinput + "/bedtoolsCommands.txt", "w")
captureCommands()
text_file2.close()

os.system("mkdir " + fileinput + "/man")
os.system("mkdir " + fileinput + "/R")
os.system("mkdir " + fileinput + "/dev")
text_file4 = open(fileinput + "/dev/log.txt", "w")
text_file3 = open(fileinput + "/bedtoolsCommands.txt", "r")

for line in text_file3:
    if line.startswith("makewindows") or line.startswith("split"):
        continue
    createR = 1
    optionDict.clear()
    infoDict.clear()
    usageDict.clear()
    snippedLine = line[:-1]
    os.system("%s %s -h &> %s/bedtools%s.txt" % (bedtoolsinputmain, snippedLine, fileinput, snippedLine))
    text_file = open("%s/bedtools%s.txt" % (fileinput, snippedLine), "r+")
    currentoption = line
    basic()
    options()
    if (createR == 1):
        bedtoolsFunction(snippedLine)
        functionList.append(line.rstrip())
    text_file.close()
    os.system("rm %s/bedtools%s.txt" % (fileinput, snippedLine))

text_file3.close()
text_file4.close()
os.system("rm %s/bedtools.txt" % fileinput)
os.system("rm %s/bedtoolsCommands.txt" % fileinput)
f=open("%s/DESCRIPTION" % fileinput, "w")
f.write("Package: bedtoolsr\n")
f.write("Encoding: UTF-8\n")
f.write("Type: Package\n")
f.write("Title: Bedtools Wrapper\n")
f.write("Version: %s-%d\n" % (version[1:], versionsuffix))
today = datetime.date.today()
f.write("Date: "+ str(today) + "\n")
f.write("Author: Mayura Patwardhan, Craig Wenger, Doug Phanstiel\n")
f.write("Description: The purpose of my project is to write an R package that allows seamless use of bedtools from within the R environment. To accomplish this, I will write a python script that reads in the bedtools code and writes the entire R package.  By generating the code in this fashion, we can ensure that our package can easily be generated for all current and future versions of bedtools.\n")
f.write("License: MIT\n")
f.close()
f = open("%s/NAMESPACE" % fileinput, "w")
exportfunctions = ""
for function in functionList:
    exportfunctions = exportfunctions + function + ", "
exportfunctions = exportfunctions[:-2]
f.write("export(" + exportfunctions + ")")
f = open("%s/R/zzz.r" % fileinput, "w")
f.write("""
.onLoad <- function(libname, pkgname) {
    installed.packages<-installed.packages()
    row<-which(installed.packages[, 1]=="bedtoolsr")
    if(length(row)>0) {
        bedtoolsr_version<-installed.packages[row, 3]
        hyphens<-gregexpr("-", bedtoolsr_version)
        response<-tryCatch({
            bedtools.path <- getOption("bedtools.path")
            if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
            system(paste0(bedtools.path, "bedtools --version"), intern=T)
        }, error = function(e) {
            warning("bedtools does not appear to be installed or not in your PATH. If it is installed, please add it to your PATH or run:\noptions(bedtools.path = \\\"[bedtools path]\\\")")
            return(NULL)
        })
        if(!is.null(response)) {
            installed_bedtools_version<-substr(response, 11, nchar(response))
            package_bedtools_version<-substr(bedtoolsr_version, 1, hyphens[[length(hyphens)]][1]-1)
            if(installed_bedtools_version != package_bedtools_version) {
            warning(paste("bedtoolsr was built with bedtools version", package_bedtools_version, "but you have version", installed_bedtools_version, "installed. Function syntax may have changed and wrapper will not function correctly. To fix this, please install bedtools version", package_bedtools_version, "and either add it to your PATH or run:\noptions(bedtools.path = \\\"[bedtools path]\\\")"))
            }
        }
    }
}
""")
f.close()

#------- Make helper R functions -------#

# Define a function to create options
f = open("%s/R/createOptions.r" % fileinput, "w")
f.write("""
#' Creates options based on user input
#' 
#' @param names vector of names of options
#' @param values vector of values of options
#' 
#' ### Define a function that determines establishes files and paths for bedtools functions
createOptions <- function(names,values)
{
  
  options = "" 
  if (length(names) > 0)
  {
   for (i in 1:length(names))
   {
    if (!is.null(values[[i]])) {
     options = paste(options,paste(" -",names[i],sep=""))
     if(is.character(values[[i]]) || is.numeric(values[[i]])) {
      options = paste(options, " ", values[i])
     }   
    }
   }
  }
  
  # return the two items
  return (options)
}
""")
f.close()


# Define a function make and record temp files
f = open("%s/R/establishPaths.r" % fileinput, "w")
f.write("""
#' Determines if arguments are paths or R objects. Makes temp files when
#' neccesary. Makes a list of files to use in bedtools call. Makes a list
#' of temp files to delete at end of function 
#' 
#' @param input the input for an argument.  Could be a path to a file, an R object (data frame), or a list of any combination thereof
#' @param name the name of the argument
#' @param allowRobjects boolean whether or not to allow R objects as inputs
#' 
#' ### Define a function that determines establishes files and paths for bedtools functions
establishPaths <- function(input,name="",allowRobjects=TRUE)
{
  # convert to list if neccesary
  if (!inherits(input, "list")  )
  {
    input = list(input)
  }
  
  # iterate through list making files where neccesary and recording tmp files for deletion
  i = 0
  inputpaths = c()
  inputtmps  = c()
  for (item in input)
  {
    i = i + 1
    filepath = item
    # if it is an R object
    if (!is.character(item) && !is.numeric(item)) {
      
      if (allowRobjects == FALSE)
      {
        stop("R objects are not permitted as arguments for",name)
      }
      
      # write a temp file
      filepath = paste0(tempdir(), "/" ,name,"_",i,".txt")
      write.table(item, filepath, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
      
      # record temp file for deletion
      inputtmps = c(inputtmps,filepath)
    }
    
    # record file path for use
    inputpaths = c(inputpaths,filepath)
  }
  
  # join them by spaces
  finalargument = paste(inputpaths,collapse=" ")
  
  # return the two items
  return (list(finalargument,inputtmps))
}
""")
f.close()

# Define a function to delete temp files
f = open("%s/R/deleteTempfiles.r" % fileinput, "w")
f.write("""
#' Deletes temp files
#' 
#' @param tempfiles a vector of tempfiles for deletion
#' 
#' ### Define a function that determines establishes files and paths for bedtools functions
deleteTempfiles <- function(tempfiles)
{
  for (tempfile in tempfiles)
  {
    if(exists(tempfile)) { 
      file.remove (tempfile)
    } 
  }
}
""")
f.close()

