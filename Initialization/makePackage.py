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
		text_file4.write(currentoption.rstrip() + " could not be created because "+ header[:-1] +" did not exist\n")
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
	
	file = open(fileinput+"/BedtoolsR%s/R/%s.r" % (version,command),"w")

	summarySplit = infoDict["Summary"].split("\n")

	for line in summarySplit:
		file.write(comment+line)
		file.write("\n")

	for key in usageDict:
		usageLines =  "@param " + key + " " + usageDict[key].replace("%", " percent")
		usageSplit = usageLines.split("\n")
		for line in usageSplit:
			file.write(comment+line)
			file.write("\n")
		
	for option in optionDict:
		optionLines = "@param " + option + " " + optionDict[option].replace("%", " percent")
		optionSplit = optionLines.split("\n")
		for line in optionSplit:
			file.write(comment+line)
			file.write("\n")



	setOptions= ""
	for option in optionDict:
		setOptions = setOptions + option + " = " + "NULL" + ", "

	setOptions = setOptions[:-2]

	usageDictOptions = ""

	for key in usageDict:
		usageDictOptions = usageDictOptions + key + ", "
	if (len(setOptions) == 0):
		usageDictOptions = usageDictOptions[:-2]
	file.write(infoDict["ToolName"] + " <- " + "function(" + usageDictOptions  + setOptions + ")\n")


	file.write ("{ \n")
	for key in usageDict:
		file.write("""
			if (!is.character(%s) && !is.numeric(%s)) {
			%sTable = "~/Desktop/%sTable.txt"
			write.table(%s, %sTable, append = "FALSE", sep = "\t", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			%s=%sTable } 
			""" % (key, key, key, key, key, key, key, key))
	file.write ("\n")
	file.write('\t\toptions = "" \n' )

	for option in optionDict:
		file.write(""" 
			if (!is.null(%s)) {
			options = paste(options," -%s")
			if(is.character(%s) || is.numeric(%s)) {
			options = paste(options, " ", %s)
			}	
			}
			""" % (option, option, option, option, option))

	file.write('\n\t# establish output file \n\ttempfile = "~/Desktop/tempfile.txt" \n' )
	cmdstring = ""
	for key in usageDict:
		cmdstring = cmdstring + ', " -%s ", %s' % (key, key)

	file.write('\tcmd = paste("%s ' %bedtoolsinputmain + infoDict["ToolName"].rstrip() + ' ", options' + cmdstring + ', " > ", tempfile) \n\tsystem(cmd) \n')
	file.write('\tresults = read.table(tempfile,header=FALSE,sep="\\t")')
	file.write(""" 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		""")
	for key in usageDict:
		file.write(""" 
		if(exists("%sTable")) { 
		file.remove (%sTable)
		} """ % (key, key))
		file.write ("\n")


while True: 
	fileinput = input("Where would you like to make your R package? Type the full path name below:").rstrip()
	if not fileinput:
		continue
	if(os.path.isdir(fileinput) == False):
	 	print("This is not a valid path")
	 	continue
	else:
		break

bedtoolsinput = input("What is the bedtools path?")
if(bedtoolsinput == ""):
    bedtoolsinputmain = "bedtools"
else:
    bedtoolsinputmain = bedtoolsinput+"/bedtools"

os.system("%s &> %s/bedtools.txt" %(bedtoolsinputmain,fileinput))
text_file2 = open(fileinput+"/bedtools.txt", "r")
text_file3 = open(fileinput+"/bedtoolsCommands.txt", "w")
captureCommands()
text_file2.close()


os.system("mkdir " + fileinput + "/BedtoolsR%s" % version)
os.system("mkdir "+ fileinput +"/BedtoolsR%s/man" %version)
os.system("mkdir "+fileinput+ "/BedtoolsR%s/R" %version)
text_file4 = open(fileinput+"/BedtoolsR%s/logFile.txt" %version, "w")
text_file3 = open(fileinput+"/bedtoolsCommands.txt", "r")

for line in text_file3:
	createR = 1
	optionDict.clear()
	infoDict.clear()
	usageDict.clear()
	snippedLine = line[:-1]
	os.system("%s %s -h &> %s/BedtoolsR%s/bedtools%s.txt" % (bedtoolsinputmain, snippedLine, fileinput, version, snippedLine))
	text_file = open("%s/BedtoolsR%s/bedtools%s.txt" % (fileinput,version, snippedLine), "r+")
	currentoption = line
	basic()
	options()
	if (createR == 1):
		bedtoolsFunction(snippedLine)
		functionList.append(line.rstrip())
	text_file.close()
	os.system("rm %s/BedtoolsR%s/bedtools%s.txt" % (fileinput, version, snippedLine))

text_file3.close()
text_file4.close()
os.system("rm %s/bedtools.txt" % fileinput)
os.system("rm %s/bedtoolsCommands.txt" % fileinput)
f=open("%s/BedtoolsR%s/DESCRIPTION" % (fileinput, version), "w")
f.write("Package: BedtoolsR\n")
f.write("Encoding: UTF-8\n")
f.write("Type: Package\n")
f.write("Title: Bedtools Wrapper\n")
f.write("Version: "+ version[1:]+"\n")
today = datetime.date.today()
f.write("Date: "+ str(today) + "\n")
f.write("Author: Mayura Patwardhan, Doug Phanstiel\n")
f.write("Description: The purpose of my project is to write an R package that allows seamless use of bedtools from within the R environment. To accomplish this, I will write a python script that reads in the bedtools code and writes the entire R package.  By generating the code in this fashion, we can ensure that our package can easily be generated for all current and future versions of bedtools.\n")
f.write("License: What license is it under?\n")
f.close()
f = open("%s/BedtoolsR%s/NAMESPACE" % (fileinput, version), "w")
exportfunctions = ""
for function in functionList:
	exportfunctions = exportfunctions + function + ", "
exportfunctions = exportfunctions[:-2]
f.write("export("+exportfunctions+")")




