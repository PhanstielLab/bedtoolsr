#' Summarizes a dataset column based upon
#' common column groupings. Akin to the SQL "group by" command.
#' 
#' @param i <bed/gff/vcf/bam>
#' @param g <group columns>
#' @param c <op. column>
#' @param o <operation>
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
#' @param output Output filepath instead of returning output in R.
#' 
bt.groupby <- function(i, g = NULL, c = NULL, o = NULL, full = NULL, inheader = NULL, outheader = NULL, header = NULL, ignorecase = NULL, prec = NULL, delim = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("g", "c", "o", "full", "inheader", "outheader", "header", "ignorecase", "prec", "delim"), values=list(g, c, o, full, inheader, outheader, header, ignorecase, prec, delim))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools groupby ", options, " -i ", i[[1]], " > ", tempfile)
	if(.Platform$OS.type == "windows") shell(cmd) else system(cmd)
	if(!is.null(output)) {
		if(file.info(tempfile)$size > 0)
			file.copy(tempfile, output)
	} else {
		if(file.info(tempfile)$size > 0)
			results <- utils::read.table(tempfile, header=FALSE, sep="\t", quote='')
		else
			results <- data.frame()
	}

	# Delete temp files
	temp.files <- c(tempfile, i[[2]])
	deleteTempFiles(temp.files)

	if(is.null(output))
		return(results)
}