#' Combines multiple BedGraph files into a single file,
#' allowing coverage comparisons between them.
#' 
#' @param i FILE1 FILE2 .. FILEn
#'   Assumes that each BedGraph file is sorted by chrom/start 
#'   and that the intervals in each are non-overlapping.
#' @param header Print a header line.
#'     (chrom/start/end + names of each file).
#' 
#' @param names A list of names (one/file) to describe each file in -i.
#'     These names will be printed in the header line.
#' 
#' @param g Use genome file to calculate empty regions.
#'     - STRING.
#' 
#' @param empty Report empty regions (i.e., start/end intervals w/o
#'     values in all files).
#'     - Requires the '-g FILE' parameter.
#' 
#' @param filler Use TEXT when representing intervals having no value.
#'     - Default is '0', but you can use 'N/A' or any text.
#' 
#' @param examples Show detailed usage examples.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.unionbedg <- function(i, header = NULL, names = NULL, g = NULL, empty = NULL, filler = NULL, examples = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("header", "names", "g", "empty", "filler", "examples"), values=list(header, names, g, empty, filler, examples))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools unionbedg ", options, " -i ", i[[1]], " > ", tempfile)
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
	deleteTempFiles(c(tempfile, i[[2]]))

	if(is.null(output))
		return(results)
}