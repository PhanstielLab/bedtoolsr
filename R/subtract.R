#' Removes the portion(s) of an interval that is overlapped
#' by another feature(s).
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param A Remove entire feature if any overlap.  That is, by default,
#'   only subtract the portion of A that overlaps B. Here, if
#'   any overlap is found (or -f amount), the entire feature is removed.
#' 
#' @param N Same as -A except when used with -f, the amount is the sum
#'   of all features (not any single feature).
#' 
#' @param wb Write the original entry in B for each overlap.
#'   - Useful for knowing _what_ A overlaps. Restricted by -f and -r.
#' 
#' @param wo Write the original A and B entries plus the number of base
#'   pairs of overlap between the two features.
#'   - Overlaps restricted by -f and -r.
#'     Only A features with overlap are reported.
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
#' @param sorted Use the "chromsweep" algorithm for sorted (-k1,1 -k2,2n) input.
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
subtract <- function(a, b, A = NULL, N = NULL, wb = NULL, wo = NULL, s = NULL, S = NULL, f = NULL, F = NULL, r = NULL, e = NULL, split = NULL, g = NULL, nonamecheck = NULL, sorted = NULL, bed = NULL, header = NULL, nobuf = NULL, iobuf = NULL)
{ 
	# Required Inputs
	a = establishPaths(input=a,name="a",allowRobjects=TRUE)
	b = establishPaths(input=b,name="b",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("A","N","wb","wo","s","S","f","F","r","e","split","g","nonamecheck","sorted","bed","header","nobuf","iobuf"),values= list(A,N,wb,wo,s,S,f,F,r,e,split,g,nonamecheck,sorted,bed,header,nobuf,iobuf))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools subtract ", options, " -a ", a[[1]], " -b ", b[[1]], " > ", tempfile) 
	system(cmd) 
	results = utils::read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempFiles(c(tempfile,a[[2]],b[[2]]))
	return (results)
}