#' Replicate lines in a file based on columns of comma-separated values.
#' 
#' @param c 
#' @param i Input file. Assumes "stdin" if omitted.
#' 
expand <- function(c, i = NULL)
{ 
	# Required Inputs
	c = establishPaths(input=c,name="c",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("i"),values= list(i))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools expand ", options, " -c ", c[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempfiles(c(tempfile,c[[2]]))
	return (results)
}