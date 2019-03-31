#' Replicate lines in a file based on columns of comma-separated values.
#' 
#' @param i <bed/gff/vcf/bam>
#' @param c 
#' @param output Output filepath instead of returning output in R.
#' 
expand <- function(i, c = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("c"), values=list(c))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools expand ", options, " -i ", i[[1]], " > ", tempfile)
	system(cmd)
	if(!is.null(output))
		file.copy(tempfile, output)
	else
		results <- utils::read.table(tempfile, header=FALSE, sep="\t")

	# Delete temp files
	deleteTempFiles(c(tempfile, i[[2]]))

	if(is.null(output))
		return(results)
}