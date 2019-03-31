#' Computes the amount of overlap (positive values)
#' or distance (negative values) between genome features
#' and reports the result at the end of the same line.
#' 
#' @param i <bed/gff/vcf/bam>
#' @param cols <columns>
overlap <- function(i, cols = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("cols"), values=list(cols))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools overlap ", options, " -i ", i[[1]], " > ", tempfile)
	system(cmd)
	results <- utils::read.table(tempfile, header=FALSE, sep="\t")

	# Delete temp files
	deleteTempFiles(c(tempfile, i[[2]]))

	return(results)
}