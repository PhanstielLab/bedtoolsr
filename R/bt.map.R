#' Apply a function to a column from B intervals that overlap A.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param c Specify columns from the B file to map onto intervals in A.
#'   Default: 5.
#'   Multiple columns can be specified in a comma-delimited list.
#' 
#' @param o Specify the operation that should be applied to -c.
#'   Valid operations:
#'       sum, min, max, absmin, absmax,
#'       mean, median, mode, antimode
#'       stdev, sstdev
#'       collapse (i.e., print a delimited list (duplicates allowed)), 
#'       distinct (i.e., print a delimited list (NO duplicates allowed)), 
#'       distinct_sort_num (as distinct, sorted numerically, ascending),
#'       distinct_sort_num_desc (as distinct, sorted numerically, desscending),
#'       distinct_only (delimited list of only unique values),
#'       count
#'       count_distinct (i.e., a count of the unique values in the column), 
#'       first (i.e., just the first value in the column), 
#'       last (i.e., just the last value in the column), 
#'   Default: sum
#'   Multiple operations can be specified in a comma-delimited list.
#'   If there is only column, but multiple operations, all operations will be
#'   applied on that column. Likewise, if there is only one operation, but
#'   multiple columns, that operation will be applied to all columns.
#'   Otherwise, the number of columns must match the the number of operations,
#'   and will be applied in respective order.
#'   E.g., "-c 5,4,6 -o sum,mean,count" will give the sum of column 5,
#'   the mean of column 4, and the count of column 6.
#'   The order of output columns will match the ordering given in the command.
#' 
#' @param delim Specify a custom delimiter for the collapse operations.
#'   - Example: -delim "|"
#'   - Default: ",".
#' 
#' @param prec Sets the decimal precision for output (Default: 5)
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
bt.map <- function(a, b, c = NULL, o = NULL, delim = NULL, prec = NULL, s = NULL, S = NULL, f = NULL, F = NULL, r = NULL, e = NULL, split = NULL, g = NULL, nonamecheck = NULL, bed = NULL, header = NULL, nobuf = NULL, iobuf = NULL, output = NULL)
{
	# Required Inputs
	a <- establishPaths(input=a, name="a", allowRobjects=TRUE)
	b <- establishPaths(input=b, name="b", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("c", "o", "delim", "prec", "s", "S", "f", "F", "r", "e", "split", "g", "nonamecheck", "bed", "header", "nobuf", "iobuf"), values=list(c, o, delim, prec, s, S, f, F, r, e, split, g, nonamecheck, bed, header, nobuf, iobuf))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools map ", options, " -a ", a[[1]], " -b ", b[[1]], " > ", tempfile)
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