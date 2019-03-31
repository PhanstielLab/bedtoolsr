#' For each feature in A, finds the closest 
#' feature (upstream or downstream) in B.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param d In addition to the closest feature in B, 
#'   report its distance to A as an extra column.
#'   - The reported distance for overlapping features will be 0.
#' 
#' @param D Like -d, report the closest feature in B, and its distance to A
#'   as an extra column. Unlike -d, use negative distances to report
#'   upstream features.
#'   The options for defining which orientation is "upstream" are:
#'   - "ref"   Report distance with respect to the reference genome. 
#'               B features with a lower (start, stop) are upstream
#'   - "a"     Report distance with respect to A.
#'               When A is on the - strand, "upstream" means B has a
#'               higher (start,stop).
#'   - "b"     Report distance with respect to B.
#'               When B is on the - strand, "upstream" means A has a
#'               higher (start,stop).
#' 
#' @param io Ignore features in B that overlap A.  That is, we want close,
#'   yet not touching features only.
#' 
#' @param iu Ignore features in B that are upstream of features in A.
#'   This option requires -D and follows its orientation
#'   rules for determining what is "upstream".
#' 
#' @param id Ignore features in B that are downstream of features in A.
#'   This option requires -D and follows its orientation
#'   rules for determining what is "downstream".
#' 
#' @param fu Choose first from features in B that are upstream of features in A.
#'   This option requires -D and follows its orientation
#'   rules for determining what is "upstream".
#' 
#' @param fd Choose first from features in B that are downstream of features in A.
#'   This option requires -D and follows its orientation
#'   rules for determining what is "downstream".
#' 
#' @param t How ties for closest feature are handled.  This occurs when two
#'   features in B have exactly the same "closeness" with A.
#'   By default, all such features in B are reported.
#'   Here are all the options:
#'   - "all"    Report all ties (default).
#'   - "first"  Report the first tie that occurred in the B file.
#'   - "last"   Report the last tie that occurred in the B file.
#' 
#' @param mdb How multiple databases are resolved.
#'   - "each"    Report closest records for each database (default).
#'   - "all"  Report closest records among all databases.
#' 
#' @param k Report the k closest hits. Default is 1. If tieMode = "all", 
#'   - all ties will still be reported.
#' 
#' @param N Require that the query and the closest hit have different names.
#'   For BED, the 4th column is compared.
#' 
#' @param s Require same strandedness.  That is, only report hits in B
#'   that overlap A on the _same_ strand.
#'   - By default, overlaps are reported without respect to strand.
#' 
#' @param S Require different strandedness.  That is, only report hits in B
#'   that overlap A on the _opposite_ strand.
#'   - By default, overlaps are reported without respect to strand.
#' 
#' @param f Minimum overlap required as a fraction of A.
#'   - Default is 1E-9 (i.e., 1bp).
#'   - FLOAT (e.g. 0.50)
#' 
#' @param F Minimum overlap required as a fraction of B.
#'   - Default is 1E-9 (i.e., 1bp).
#'   - FLOAT (e.g. 0.50)
#' 
#' @param r Require that the fraction overlap be reciprocal for A AND B.
#'   - In other words, if -f is 0.90 and -r is used, this requires
#'     that B overlap 90 percent of A and A _also_ overlaps 90 percent of B.
#' 
#' @param e Require that the minimum fraction be satisfied for A OR B.
#'   - In other words, if -e is used with -f 0.90 and -F 0.10 this requires
#'     that either 90 percent of A is covered OR 10 percent of  B is covered.
#'     Without -e, both fractions would have to be satisfied.
#' 
#' @param split Treat "split" BAM or BED12 entries as distinct BED intervals.
#' 
#' @param g Provide a genome file to enforce consistent chromosome sort order
#'   across input files. Only applies when used with -sorted option.
#' 
#' @param nonamecheck For sorted data, don't throw an error if the file has different naming conventions
#'     for the same chromosome. ex. "chr1" vs "chr01".
#' 
#' @param names When using multiple databases, provide an alias for each that
#'   will appear instead of a fileId when also printing the DB record.
#' 
#' @param filenames When using multiple databases, show each complete filename
#'     instead of a fileId when also printing the DB record.
#' 
#' @param sortout When using multiple databases, sort the output DB hits
#'     for each record.
#' 
#' @param bed If using BAM input, write output as BED.
#' 
#' @param header Print the header from the A file prior to results.
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
#' @param output Output filepath instead of returning output in R.
#' 
closest <- function(a, b, d = NULL, D = NULL, io = NULL, iu = NULL, id = NULL, fu = NULL, fd = NULL, t = NULL, mdb = NULL, k = NULL, N = NULL, s = NULL, S = NULL, f = NULL, F = NULL, r = NULL, e = NULL, split = NULL, g = NULL, nonamecheck = NULL, names = NULL, filenames = NULL, sortout = NULL, bed = NULL, header = NULL, nobuf = NULL, iobuf = NULL, output = NULL)
{
	# Required Inputs
	a <- establishPaths(input=a, name="a", allowRobjects=TRUE)
	b <- establishPaths(input=b, name="b", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("d", "D", "io", "iu", "id", "fu", "fd", "t", "mdb", "k", "N", "s", "S", "f", "F", "r", "e", "split", "g", "nonamecheck", "names", "filenames", "sortout", "bed", "header", "nobuf", "iobuf"), values=list(d, D, io, iu, id, fu, fd, t, mdb, k, N, s, S, f, F, r, e, split, g, nonamecheck, names, filenames, sortout, bed, header, nobuf, iobuf))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools closest ", options, " -a ", a[[1]], " -b ", b[[1]], " > ", tempfile)
	system(cmd)
	if(!is.null(output))
		file.copy(tempfile, output)
	else
		results <- utils::read.table(tempfile, header=FALSE, sep="\t")

	# Delete temp files
	deleteTempFiles(c(tempfile, a[[2]], b[[2]]))

	if(is.null(output))
		return(results)
}