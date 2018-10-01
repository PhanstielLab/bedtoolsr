import os 
import datetime
import time
# define dictionaries
optionDict = {}
infoDict = {}
usageDict = {}
version = ""
createR = 1
now = datetime.datetime.now()




#captures all the commands in main bedtools menu
def captureCommands():
	text_file2.seek(0)
	for line in text_file2:
		words = line.split(" ")
		if(line[:4] == '    ' and line[4] != '-'):
			text_file3.write(words[4]+"\n")

#captures all of the information below a header until next1 or next2
def capture(header, header1):
	global createR
	

	#start at the beginning of text file
	text_file.seek(0)


	#split each line by a space
	for line in text_file:
		words = line.split(" ")

		firstWord = words[0]
		#print(words)

		#add to word and definition
		if(firstWord == header or firstWord == header1):
			definition = ""
			word = header[:-1]
			definition = (" ").join(words[1:]).lstrip()
			break					

	#print none if the header does not exist
	if(firstWord != header and firstWord != header1):	
		createR = 0
		text_file4.write("R file could not be created because "+ header[:-1] +" did not exist\n")
		return
	

	#print the lines before the next header
	for line in text_file:
		read = line.split(" ")
		#print(read)
		if (len(read[0])>0): 
			if(read[0][-1] == ":" or (read[0][-2:] == ":\t") or (read[0][-2:] == ":\n")):
		 		break
		definition = definition + line.lstrip()
	

	#add word to dictionary					
	infoDict[word] = definition 


def basic() :
	#check makewindows. 
	global version

	capture("Tool:", "Tool:\n")
	infoDict["ToolName"] = infoDict["Tool"].split(" ")[1]
	capture("Version:", "Version\n")
	version = infoDict["Version"]
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
				optionDict[word] = definition
		
		#if the line is not blank but does not have a word on the second element it is a continuation of the previous definition
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
	
	comment = "#' "
	file = open("/Users/mayurapatwardhan/Documents/Bedtools/BedtoolsRWrapper/R/%s.r" %command,"w")

	summarySplit = infoDict["Summary"].split("\n")

	for line in summarySplit:
		file.write(comment+line)
		file.write("\n")

	for key in usageDict:
		usageLines =  "@param " + key + " " + usageDict[key]
		usageSplit = usageLines.split("\n")
		for line in usageSplit:
			file.write(comment+line)
			file.write("\n")
		
	for option in optionDict:
		optionLines = "@param " + option + " " + optionDict[option]
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
	file.write(infoDict["ToolName"] + " <- " + "function(" + usageDictOptions  + setOptions + ")\n")


	file.write ("{ \n")
	file.write('\toptions = "" \n' )

	for option in optionDict:
		ifConditional = "\tif (is.null("
		ifConditional = ifConditional + option + ") == FALSE) \n \t{ \n" + '\t options = paste(options," -' + option + '", sep="")' + "\n\t}\n"
		file.write(ifConditional)

	file.write('\n\t# establish output file \n\ttempfile = "~/Desktop/tempfile.txt" \n' )
	file.write('\tcmd = paste("bedtools ' + infoDict["ToolName"] + ' ", options, " -a " ,a, " -b ", b, " > ", tempfile) \n\tsystem(cmd) \n')
	file.write('\tresults = read.table(tempfile,header=FALSE,sep="\\t") \n\n\tif (file.exists(tempfile)) \n\t { \n\t file.remove(tempfile) \n\t } \n\treturn (results) \n}\n ')



os.system("bedtools &> bedtools.txt")
os.system("mkdir BedtoolsRWrapper")
os.system("mkdir /Users/mayurapatwardhan/Documents/Bedtools/BedtoolsRWrapper/man")
os.system("mkdir /Users/mayurapatwardhan/Documents/Bedtools/BedtoolsRWrapper/R")
text_file4 = open("/Users/mayurapatwardhan/Documents/Bedtools/BedtoolsRWrapper/logFile.txt", "w")
text_file3 = open("bedtoolsCommands.txt", "w")
text_file2 = open("bedtools.txt", "r")
captureCommands()
text_file2.close()
text_file3 = open("bedtoolsCommands.txt", "r")

for line in text_file3:
	createR = 1
	optionDict.clear()
	infoDict.clear()
	usageDict.clear()
	snippedLine = line[:-1]
	os.system("bedtools %s -h &> bedtools%s.txt" % (snippedLine, snippedLine))
	text_file = open("bedtools%s.txt" % snippedLine, "r+")
	basic()
	options()
	print(createR)
	if (createR == 1):
		bedtoolsFunction(snippedLine)
	text_file.close()
	os.system("rm bedtools%s.txt" % snippedLine)
	


os.system("rm bedtoolsCommands.txt")
os.system("rm bedtools.txt")
text_file3.close()
text_file4.close()

f=open("/Users/mayurapatwardhan/Documents/Bedtools/BedtoolsRWrapper/DESCRIPTION", "w")
f.write("Package: BedtoolsWrapper\n")
f.write("Type: Package\n")
f.write("Title: Bedtools Wrapper\n")
f.write("Version: "+ version[1:])
today = datetime.date.today()
f.write("Date: "+ str(today) + "\n")
f.write("Author: Mayura Patwardhan, Doug Phanstiel\n")
f.write("Description: The purpose of my project is to write an R package that allows seamless use of bedtools from within the R environment. To accomplish this, I will write a python script that reads in the bedtools code and writes the entire R package.  By generating the code in this fashion, we can ensure that our package can easily be generated for all current and future versions of bedtools.\n")
f.write("License: What license is it under?")
g=open("/Users/mayurapatwardhan/Documents/Bedtools/BedtoolsRWrapper/NAMESPACE", "w")
f.close()
g.close()
os.system("R CMD build BedtoolsRWrapper")


