#' Annotates a BAM file based on overlaps with multiple BED/GFF/VCF files
#' on the intervals in -i.
#' 
#' @param i <BAM>
#' @param files FILE1 .. FILEn
#' @param s Require overlaps on the same strand.  That is, only tag alignments that have the same
#'   strand as a feature in the annotation file(s).
#' 
#' @param S Require overlaps on the opposite strand.  That is, only tag alignments that have the opposite
#'   strand as a feature in the annotation file(s).
#' 
#' @param f Minimum overlap required as a fraction of the alignment.
#'   - Default is 1E-9 (i.e., 1bp).
#'   - FLOAT (e.g. 0.50)
#' 
#' @param tag Dictate what the tag should be. Default is YB.
#'   - STRING (two characters, e.g., YK)
#' 
#' @param names Use the name field from the annotation files to populate tags.
#'   By default, the -labels values are used.
#' 
#' @param scores Use the score field from the annotation files to populate tags.
#'   By default, the -labels values are used.
#' 
#' @param intervals Use the full interval (including name, score, and strand) to populate tags.
#'     Requires the -labels option to identify from which file the interval came.
#' 
#' @param labels LAB1 .. LABn
#' @param output Output filepath instead of returning output in R.
#' 
tag <- function(i, files, s = NULL, S = NULL, f = NULL, tag = NULL, names = NULL, scores = NULL, intervals = NULL, labels = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)
	files <- establishPaths(input=files, name="files", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("s", "S", "f", "tag", "names", "scores", "intervals", "labels"), values=list(s, S, f, tag, names, scores, intervals, labels))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools tag ", options, " -i ", i[[1]], " -files ", files[[1]], " > ", tempfile)
	system(cmd)
	if(!is.null(output))
		file.copy(tempfile, output)
	else
		results <- utils::read.table(tempfile, header=FALSE, sep="\t")

	# Delete temp files
	deleteTempFiles(c(tempfile, i[[2]], files[[2]]))

	if(is.null(output))
		return(results)
}