#' Clusters overlapping/nearby BED/GFF/VCF intervals.
#' 
#' @param i <bed/gff/vcf>
#' @param s Force strandedness.  That is, only merge features
#'   that are the same strand.
#'   - By default, merging is done without respect to strand.
#' 
#' @param d Maximum distance between features allowed for features
#'   to be merged.
#'   - Def. 0. That is, overlapping & book-ended features are merged.
#'   - (INTEGER)
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.cluster <- function(i, s = NULL, d = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("s", "d"), values=list(s, d))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path) && !grepl("wsl", bedtools.path, ignore.case=TRUE)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools cluster ", options, " -i ", i[[1]], " > ", tempfile)
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
	temp.files <- c(tempfile, i[[2]])
	deleteTempFiles(temp.files)

	if(is.null(output))
		return(results)
}