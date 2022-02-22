#' Converts feature records to BAM format.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param mapq Set the mappinq quality for the BAM records.
#'   (INT) Default: 255
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.bedpetobam <- function(i, g, mapq = NULL, ubam = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)
	g <- establishPaths(input=g, name="g", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("mapq", "ubam"), values=list(mapq, ubam))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools bedpetobam ", options, " -i ", i[[1]], " -g ", g[[1]], " > ", tempfile)
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