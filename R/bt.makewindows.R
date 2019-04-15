#' Makes adjacent or sliding windows across a genome or BED file.
#' 
#' @param g <genome> OR
#' @param b <bed>
#' @param w <window_size> OR
#' @param s <step_size>
#'   Step size: i.e., how many base pairs to step before
#'   creating a new window. Used to create "sliding" windows.
#'   - Defaults to window size (non-sliding windows).
#' 
#' @param n <number of windows>
#' @param reverse 
#'    Reverse numbering of windows in the output, i.e. report 
#'    windows in decreasing order
#' 
#' @param i src|winnum|srcwinnum
#'   The default output is 3 columns: chrom, start, end .
#'   With this option, a name column will be added.
#'    "-i src" - use the source interval's name.
#'    "-i winnum" - use the window number as the ID (e.g. 1,2,3,4...).
#'    "-i srcwinnum" - use the source interval's name with the window number.
#'   See below for usage examples.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.makewindows <- function(g = NULL, b = NULL, w = NULL, s = NULL, n = NULL, reverse = NULL, i = NULL, output = NULL)
{
	# Required Inputs
	g <- establishPaths(input=g, name="g", allowRobjects=TRUE)
	b <- establishPaths(input=b, name="b", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("w", "s", "n", "reverse", "i"), values=list(w, s, n, reverse, i))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools makewindows ", options, ifelse(!is.null(g), paste0(" -g ", g[[1]]), ""), ifelse(!is.null(b), paste0(" -b ", b[[1]]), ""), " > ", tempfile)
	system(cmd)
	if(!is.null(output)) {
		if(file.info(tempfile)$size > 0)
			file.copy(tempfile, output)
	} else {
		if(file.info(tempfile)$size > 0)
			results <- utils::read.table(tempfile, header=FALSE, sep="\t")
		else
			results <- data.frame()
	}

	# Delete temp files
	deleteTempFiles(c(tempfile, g[[2]], b[[2]]))

	if(is.null(output))
		return(results)
}