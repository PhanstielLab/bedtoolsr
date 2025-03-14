#' Converts BAM alignments to BED6 or BEDPE format.
#' 
#' @param i <bam>
#' @param bedpe Write BEDPE format.
#'   - Requires BAM to be grouped or sorted by query.
#' 
#' @param mate1 When writing BEDPE (-bedpe) format, 
#'   always report mate one as the first BEDPE "block".
#' 
#' @param bed12 Write "blocked" BED format (aka "BED12"). Forces -split.
#'   http://genome-test.cse.ucsc.edu/FAQ/FAQformat#format1
#' 
#' @param split Report "split" BAM alignments as separate BED entries.
#'   Splits only on N CIGAR operations.
#' 
#' @param splitD Split alignments based on N and D CIGAR operators.
#'   Forces -split.
#' 
#' @param ed Use BAM edit distance (NM tag) for BED score.
#'   - Default for BED is to use mapping quality.
#'   - Default for BEDPE is to use the minimum of
#'     the two mapping qualities for the pair.
#'   - When -ed is used with -bedpe, the total edit
#'     distance from the two mates is reported.
#' 
#' @param tag Use other NUMERIC BAM alignment tag for BED score.
#'   - Default for BED is to use mapping quality.
#'     Disallowed with BEDPE output.
#' 
#' @param color An R,G,B string for the color used with BED12 format.
#'   Default is (255,0,0).
#' 
#' @param cigar Add the CIGAR string to the BED entry as a 7th column.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.bamtobed <- function(i, bedpe = NULL, mate1 = NULL, bed12 = NULL, split = NULL, splitD = NULL, ed = NULL, tag = NULL, color = NULL, cigar = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=FALSE)

	options <- ""

	# Options
	options <- createOptions(names=c("bedpe", "mate1", "bed12", "split", "splitD", "ed", "tag", "color", "cigar"), values=list(bedpe, mate1, bed12, split, splitD, ed, tag, color, cigar))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path) && !grepl("wsl", bedtools.path, ignore.case=TRUE)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools bamtobed ", options, " -i ", i[[1]], " > ", tempfile)
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