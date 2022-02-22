#' Shift each feature by requested number of base pairs.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param s Shift the BED/GFF/VCF entry -s base pairs.
#'   - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param p Shift features on the + strand by -p base pairs.
#'   - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param m Shift features on the - strand by -m base pairs.
#'   - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param pct Define -s, -m and -p as a fraction of the feature's length.
#'   E.g. if used on a 1000bp feature, -s 0.50, 
#'   will shift the feature 500 bp "upstream".  Default = false.
#' 
#' @param header Print the header from the input file prior to results.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.shift <- function(i, g, s = NULL, p = NULL, m = NULL, pct = NULL, header = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)
	g <- establishPaths(input=g, name="g", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("s", "p", "m", "pct", "header"), values=list(s, p, m, pct, header))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools shift ", options, " -i ", i[[1]], " -g ", g[[1]], " > ", tempfile)
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
	deleteTempFiles(c(tempfile, i[[2]], g[[2]]))

	if(is.null(output))
		return(results)
}