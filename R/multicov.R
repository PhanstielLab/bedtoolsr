#' Counts sequence coverage for multiple bams at specific loci.
#' 
#' @param bams aln.1.bam aln.2.bam ... aln.n.bam
#' @param bed <bed/gff/vcf>
#' @param split Treat "split" BAM or BED12 entries as distinct BED intervals.
#' 
#' @param s Require same strandedness.  That is, only report hits in B
#'   that overlap A on the _same_ strand.
#'   - By default, overlaps are reported without respect to strand.
#' 
#' @param S Require different strandedness.  That is, only report hits in B
#'   that overlap A on the _opposite_ strand.
#'   - By default, overlaps are reported without respect to strand.
#' 
#' @param f Minimum overlap required as a fraction of each A.
#'   - Default is 1E-9 (i.e., 1bp).
#'   - FLOAT (e.g. 0.50)
#' 
#' @param r Require that the fraction overlap be reciprocal for each A and B.
#'   - In other words, if -f is 0.90 and -r is used, this requires
#'     that B overlap 90 percent of A and A _also_ overlaps 90 percent of B.
#' 
#' @param q Minimum mapping quality allowed. Default is 0.
#' 
#' @param D Include duplicate reads.  Default counts non-duplicates only
#' 
#' @param F Include failed-QC reads.  Default counts pass-QC reads only
#' 
#' @param p Only count proper pairs.  Default counts all alignments with
#'   MAPQ > -q argument, regardless of the BAM FLAG field.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
multicov <- function(bams, bed, split = NULL, s = NULL, S = NULL, f = NULL, r = NULL, q = NULL, D = NULL, F = NULL, p = NULL, output = NULL)
{
	# Required Inputs
	bams <- establishPaths(input=bams, name="bams", allowRobjects=TRUE)
	bed <- establishPaths(input=bed, name="bed", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("split", "s", "S", "f", "r", "q", "D", "F", "p"), values=list(split, s, S, f, r, q, D, F, p))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools multicov ", options, " -bams ", bams[[1]], " -bed ", bed[[1]], " > ", tempfile)
	system(cmd)
	if(!is.null(output))
		file.copy(tempfile, output)
	else
		results <- utils::read.table(tempfile, header=FALSE, sep="\t")

	# Delete temp files
	deleteTempFiles(c(tempfile, bams[[2]], bed[[2]]))

	if(is.null(output))
		return(results)
}