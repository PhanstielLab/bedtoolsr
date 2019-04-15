#' Split a Bed file.
#' 
#' @param i <bed>
#' @param n number-of-files
#' @param p Output BED file prefix.
#' 
#' @param a Algorithm used to split data.
#'   * size (default): uses a heuristic algorithm to group the items
#'     so all files contain the ~ same number of bases
#'   * simple : route records such that each split file has
#'     approximately equal records (like Unix split).
#' 
bt.split <- function(i, n = NULL, p = NULL, a = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("n", "p", "a"), values=list(n, p, a))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools split ", options, " -i ", i[[1]])
	console.output <- system(cmd, intern=TRUE)
	print(console.output)

	# Delete temp files
	deleteTempFiles(c(tempfile, i[[2]]))
}