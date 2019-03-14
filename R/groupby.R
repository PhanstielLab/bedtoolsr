#' Summarizes a dataset column based upon
#' common column groupings. Akin to the SQL "group by" command.
#' 
#' @param g 
#' @param c 
#' @param o 
#' @param i Input file. Assumes "stdin" if omitted.
#' 
#' @param full Print all columns from input file.  The first line in the group is used.
#'     Default: print only grouped columns.
#' 
#' @param inheader Input file has a header line - the first line will be ignored.
#' 
#' @param outheader Print header line in the output, detailing the column names. 
#'     If the input file has headers (-inheader), the output file
#'     will use the input's column names.
#'     If the input file has no headers, the output file
#'     will use "col_1", "col_2", etc. as the column names.
#' 
#' @param header same as '-inheader -outheader'
#' 
#' @param ignorecase Group values regardless of upper/lower case.
#' 
#' @param prec Sets the decimal precision for output (Default: 5)
#' 
#' @param delim Specify a custom delimiter for the collapse operations.
#'   - Example: -delim "|"
#'   - Default: ",".
#' 
groupby <- function(g, c, o, i = NULL, full = NULL, inheader = NULL, outheader = NULL, header = NULL, ignorecase = NULL, prec = NULL, delim = NULL)
{ 
	# Required Inputs
	g = establishPaths(input=g,name="g",allowRobjects=TRUE)
	c = establishPaths(input=c,name="c",allowRobjects=TRUE)
	o = establishPaths(input=o,name="o",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("i","full","inheader","outheader","header","ignorecase","prec","delim"),values= list(i,full,inheader,outheader,header,ignorecase,prec,delim))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools groupby ", options, " -g ", g[[1]], " -c ", c[[1]], " -o ", o[[1]], " > ", tempfile) 
	system(cmd) 
	results = utils::read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempFiles(c(tempfile,g[[2]],c[[2]],o[[2]]))
	return (results)
}