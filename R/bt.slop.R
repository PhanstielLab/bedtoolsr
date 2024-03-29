#' Add requested base pairs of "slop" to each feature.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param b Increase the BED/GFF/VCF entry -b base pairs in each direction.
#'   - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param l The number of base pairs to subtract from the start coordinate.
#'   - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param r The number of base pairs to add to the end coordinate.
#'   - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param s Define -l and -r based on strand.
#'   E.g. if used, -l 500 for a negative-stranded feature, 
#'   it will add 500 bp downstream.  Default = false.
#' 
#' @param pct Define -l and -r as a fraction of the feature's length.
#'   E.g. if used on a 1000bp feature, -l 0.50, 
#'   will add 500 bp "upstream".  Default = false.
#' 
#' @param header Print the header from the input file prior to results.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.slop <- function(i, g, b = NULL, l = NULL, r = NULL, s = NULL, pct = NULL, header = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)
	g <- establishPaths(input=g, name="g", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("b", "l", "r", "s", "pct", "header"), values=list(b, l, r, s, pct, header))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools slop ", options, " -i ", i[[1]], " -g ", g[[1]], " > ", tempfile)
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
	temp.files <- c(tempfile, i[[2]], g[[2]])
	deleteTempFiles(temp.files)

	if(is.null(output))
		return(results)
}