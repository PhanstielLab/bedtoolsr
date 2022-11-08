#' Generate random intervals among a genome.
#' 
#' @param g <genome>
#' @param l The length of the intervals to generate.
#'   - Default = 100.
#'   - (INTEGER)
#' 
#' @param n The number of intervals to generate.
#'   - Default = 1,000,000.
#'   - (INTEGER)
#' 
#' @param seed Supply an integer seed for the shuffling.
#'   - By default, the seed is chosen automatically.
#'   - (INTEGER)
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.random <- function(g, l = NULL, n = NULL, seed = NULL, output = NULL)
{
	# Required Inputs
	g <- establishPaths(input=g, name="g", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("l", "n", "seed"), values=list(l, n, seed))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools random ", options, " -g ", g[[1]], " > ", tempfile)
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
	temp.files <- c(tempfile, g[[2]])
	deleteTempFiles(temp.files)

	if(is.null(output))
		return(results)
}