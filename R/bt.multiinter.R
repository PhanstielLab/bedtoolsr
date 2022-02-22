#' Identifies common intervals among multiple
#' BED/GFF/VCF files.
#' 
#' @param i FILE1 FILE2 .. FILEn
#'   Requires that each interval file is sorted by chrom/start.
#' @param cluster Invoke Ryan Layers's clustering algorithm.
#' 
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
bt.multiinter <- function(i, cluster = NULL, header = NULL, names = NULL, g = NULL, empty = NULL, filler = NULL, examples = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("cluster", "header", "names", "g", "empty", "filler", "examples"), values=list(cluster, header, names, g, empty, filler, examples))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools multiinter ", options, " -i ", i[[1]], " > ", tempfile)
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