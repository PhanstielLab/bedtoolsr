#' Creates a batch script to create IGV images 
#' at each interval defined in a BED/GFF/VCF file.
#' 
#' @param i <bed/gff/vcf>
#' @param path The full path to which the IGV snapshots should be written.
#'   (STRING) Default: ./
#' 
#' @param sess The full path to an existing IGV session file to be 
#'   loaded prior to taking snapshots.
#'   (STRING) Default is for no session to be loaded.
#' 
#' @param sort The type of BAM sorting you would like to apply to each image. 
#'   Options: base, position, strand, quality, sample, and readGroup
#'   Default is to apply no sorting at all.
#' 
#' @param clps Collapse the aligned reads prior to taking a snapshot. 
#'   Default is to no collapse.
#' 
#' @param name Use the "name" field (column 4) for each image's filename. 
#'   Default is to use the "chr:start-pos.ext".
#' 
#' @param slop Number of flanking base pairs on the left & right of the image.
#'   - (INT) Default = 0.
#' 
#' @param img The type of image to be created. 
#'   Options: png, eps, svg
#'   Default is png.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.igv <- function(i, path = NULL, sess = NULL, sort = NULL, clps = NULL, name = NULL, slop = NULL, img = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("path", "sess", "sort", "clps", "name", "slop", "img"), values=list(path, sess, sort, clps, name, slop, img))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools igv ", options, " -i ", i[[1]], " > ", tempfile)
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