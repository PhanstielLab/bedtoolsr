#' Report (last col.) the gap lengths between intervals in a file.
#' 
#' @param i <bed/gff/vcf/bam>
#' @param output Output filepath instead of returning output in R.
#' 
spacing <- function(i, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c(), values=list())

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools spacing ", options, " -i ", i[[1]], " > ", tempfile)
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