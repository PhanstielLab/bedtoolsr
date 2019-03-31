#' Take sample of input file(s) using reservoir sampling algorithm.
#' 
#' @param i <bed/gff/vcf/bam>
#' @param n The number of records to generate.
#'   - Default = 1,000,000.
#'   - (INTEGER)
#' 
#' @param seed Supply an integer seed for the shuffling.
#'   - By default, the seed is chosen automatically.
#'   - (INTEGER)
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
#' @param s Require same strandedness.  That is, only give records
#'   that have the same strand. Use '-s forward' or '-s reverse'
#'   for forward or reverse strand records, respectively.
#'   - By default, records are reported without respect to strand.
#' 
#' @param header Print the header from the A file prior to results.
#' 
#' @param bed If using BAM input, write output as BED.
#' 
#' @param nobuf Disable buffered output. Using this option will cause each line
#'   of output to be printed as it is generated, rather than saved
#'   in a buffer. This will make printing large output files 
#'   noticeably slower, but can be useful in conjunction with
#'   other software tools and scripts that need to process one
#'   line of bedtools output at a time.
#' 
#' @param iobuf Specify amount of memory to use for input buffer.
#'   Takes an integer argument. Optional suffixes K/M/G supported.
#'   Note: currently has no effect with compressed files.
#' 
sample <- function(i, n = NULL, seed = NULL, ubam = NULL, s = NULL, header = NULL, bed = NULL, nobuf = NULL, iobuf = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("n", "seed", "ubam", "s", "header", "bed", "nobuf", "iobuf"), values=list(n, seed, ubam, s, header, bed, nobuf, iobuf))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools sample ", options, " -i ", i[[1]], " > ", tempfile)
	system(cmd)
	results <- utils::read.table(tempfile, header=FALSE, sep="\t")

	# Delete temp files
	deleteTempFiles(c(tempfile, i[[2]]))

	return(results)
}