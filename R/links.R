#' Creates HTML links to an UCSC Genome Browser from a feature file.
#' 
#' @param i <bed/gff/vcf> > out.html
#' @param base The browser basename.  Default: http://genome.ucsc.edu 
#' 
#' @param org The organism. Default: human
#' 
#' @param db The build.  Default: hg18
#' 
#' @param output Output filepath instead of returning output in R.
#' 
links <- function(i, base = NULL, org = NULL, db = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("base", "org", "db"), values=list(base, org, db))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools links ", options, " -i ", i[[1]], " > ", tempfile)
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