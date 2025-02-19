#' Report overlaps between a BEDPE file and a BED/GFF/VCF file.
#' 
#' @param a <bedpe>
#' @param b <bed/gff/vcf>
#' @param abam The A input file is in BAM format.  Output will be BAM as well. Replaces -a.
#'   - Requires BAM to be grouped or sorted by query.
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#'   is to write output in BAM when using -abam.
#' 
#' @param bedpe When using BAM input (-abam), write output as BEDPE. The default
#'   is to write output in BAM when using -abam.
#' 
#' @param ed Use BAM total edit distance (NM tag) for BEDPE score.
#'   - Default for BEDPE is to use the minimum of
#'     of the two mapping qualities for the pair.
#'   - When -ed is used the total edit distance
#'     from the two mates is reported as the score.
#' 
#' @param f Minimum overlap required as fraction of A (e.g. 0.05).
#'   Default is 1E-9 (effectively 1bp).
#' 
#' @param s Require same strandedness when finding overlaps.
#'   Default is to ignore stand.
#'   Not applicable with -type inspan or -type outspan.
#' 
#' @param S Require different strandedness when finding overlaps.
#'   Default is to ignore stand.
#'   Not applicable with -type inspan or -type outspan.
#' 
#' @param type Approach to reporting overlaps between BEDPE and BED.
#'   either Report overlaps if either end of A overlaps B.
#'     - Default.
#'   neither Report A if neither end of A overlaps B.
#'   both Report overlaps if both ends of A overlap  B.
#'   xor Report overlaps if one and only one end of A overlaps B.
#'   notboth Report overlaps if neither end or one and only one 
#'     end of A overlap B.  That is, xor + neither.
#'   ispan Report overlaps between [end1, start2] of A and B.
#'     - Note: If chrom1 <> chrom2, entry is ignored.
#'   ospan Report overlaps between [start1, end2] of A and B.
#'     - Note: If chrom1 <> chrom2, entry is ignored.
#'   notispan Report A if ispan of A doesn't overlap B.
#'      - Note: If chrom1 <> chrom2, entry is ignored.
#'   notospan Report A if ospan of A doesn't overlap B.
#'      - Note: If chrom1 <> chrom2, entry is ignored.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.pairtobed <- function(a, b, abam = NULL, ubam = NULL, bedpe = NULL, ed = NULL, f = NULL, s = NULL, S = NULL, type = NULL, output = NULL)
{
	# Required Inputs
	a <- establishPaths(input=a, name="a", allowRobjects=TRUE)
	b <- establishPaths(input=b, name="b", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("abam", "ubam", "bedpe", "ed", "f", "s", "S", "type"), values=list(abam, ubam, bedpe, ed, f, s, S, type))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path) && !grepl("wsl", bedtools.path, ignore.case=TRUE)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools pairtobed ", options, " -a ", a[[1]], " -b ", b[[1]], " > ", tempfile)
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
	temp.files <- c(tempfile, a[[2]], b[[2]])
	deleteTempFiles(temp.files)

	if(is.null(output))
		return(results)
}