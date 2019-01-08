#' Apply a function to a column from B intervals that overlap A.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param c Specify columns from the B file to map onto intervals in A.
#' Default: 5.
#' Multiple columns can be specified in a comma-delimited list.
#' 
#' @param e Require that the minimum fraction be satisfied for A OR B.
#' - In other words, if -e is used with -f 0.90 and -F 0.10 this requires
#'   that either 90 percent of A is covered OR 10 percent of  B is covered.
#'   Without -e, both fractions would have to be satisfied.
#' 
#' @param bed If using BAM input, write output as BED.
#' 
#' @param g Provide a genome file to enforce consistent chromosome sort order
#' across input files. Only applies when used with -sorted option.
#' 
#' @param f Minimum overlap required as a fraction of A.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param F Minimum overlap required as a fraction of B.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param delim Specify a custom delimiter for the collapse operations.
#' - Example: -delim "|"
#' - Default: ",".
#' 
#' @param s Require same strandedness.  That is, only report hits in B
#' that overlap A on the _same_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param prec Sets the decimal precision for output (Default: 5)
#' 
#' @param header Print the header from the A file prior to results.
#' 
#' @param S Require different strandedness.  That is, only report hits in B
#' that overlap A on the _opposite_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param r Require that the fraction overlap be reciprocal for A AND B.
#' - In other words, if -f is 0.90 and -r is used, this requires
#'   that B overlap 90 percent of A and A _also_ overlaps 90 percent of B.
#' 
#' @param nobuf Disable buffered output. Using this option will cause each line
#' of output to be printed as it is generated, rather than saved
#' in a buffer. This will make printing large output files 
#' noticeably slower, but can be useful in conjunction with
#' other software tools and scripts that need to process one
#' line of bedtools output at a time.
#' 
#' @param o Specify the operation that should be applied to -c.
#' Valid operations:
#'     sum, min, max, absmin, absmax,
#'     mean, median, mode, antimode
#'     stdev, sstdev
#'     collapse (i.e., print a delimited list (duplicates allowed)), 
#'     distinct (i.e., print a delimited list (NO duplicates allowed)), 
#'     distinct_sort_num (as distinct, sorted numerically, ascending),
#'     distinct_sort_num_desc (as distinct, sorted numerically, desscending),
#'     distinct_only (delimited list of only unique values),
#'     count
#'     count_distinct (i.e., a count of the unique values in the column), 
#'     first (i.e., just the first value in the column), 
#'     last (i.e., just the last value in the column), 
#' Default: sum
#' Multiple operations can be specified in a comma-delimited list.
#' If there is only column, but multiple operations, all operations will be
#' applied on that column. Likewise, if there is only one operation, but
#' multiple columns, that operation will be applied to all columns.
#' Otherwise, the number of columns must match the the number of operations,
#' and will be applied in respective order.
#' E.g., "-c 5,4,6 -o sum,mean,count" will give the sum of column 5,
#' the mean of column 4, and the count of column 6.
#' The order of output columns will match the ordering given in the command.
#' 
#' @param nonamecheck For sorted data, don't throw an error if the file has different naming conventions
#'  for the same chromosome. ex. "chr1" vs "chr01".
#' 
#' @param iobuf Specify amount of memory to use for input buffer.
#' Takes an integer argument. Optional suffixes K/M/G supported.
#' Note: currently has no effect with compressed files.
#' 
#' @param split Treat "split" BAM or BED12 entries as distinct BED intervals.
#' 
map <- function(a, b, c = NULL, e = NULL, bed = NULL, g = NULL, f = NULL, F = NULL, delim = NULL, s = NULL, prec = NULL, header = NULL, S = NULL, r = NULL, nobuf = NULL, o = NULL, nonamecheck = NULL, iobuf = NULL, split = NULL)
{ 

			if (!is.character(a) && !is.numeric(a)) {
			aTable = "~/Desktop/aTable.txt"
			write.table(a, aTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			a=aTable } 
			
			if (!is.character(b) && !is.numeric(b)) {
			bTable = "~/Desktop/bTable.txt"
			write.table(b, bTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			b=bTable } 
			
		options = "" 
 
			if (!is.null(c)) {
			options = paste(options," -c")
			if(is.character(c) || is.numeric(c)) {
			options = paste(options, " ", c)
			}	
			}
			 
			if (!is.null(e)) {
			options = paste(options," -e")
			if(is.character(e) || is.numeric(e)) {
			options = paste(options, " ", e)
			}	
			}
			 
			if (!is.null(bed)) {
			options = paste(options," -bed")
			if(is.character(bed) || is.numeric(bed)) {
			options = paste(options, " ", bed)
			}	
			}
			 
			if (!is.null(g)) {
			options = paste(options," -g")
			if(is.character(g) || is.numeric(g)) {
			options = paste(options, " ", g)
			}	
			}
			 
			if (!is.null(f)) {
			options = paste(options," -f")
			if(is.character(f) || is.numeric(f)) {
			options = paste(options, " ", f)
			}	
			}
			 
			if (!is.null(F)) {
			options = paste(options," -F")
			if(is.character(F) || is.numeric(F)) {
			options = paste(options, " ", F)
			}	
			}
			 
			if (!is.null(delim)) {
			options = paste(options," -delim")
			if(is.character(delim) || is.numeric(delim)) {
			options = paste(options, " ", delim)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			 
			if (!is.null(prec)) {
			options = paste(options," -prec")
			if(is.character(prec) || is.numeric(prec)) {
			options = paste(options, " ", prec)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(S)) {
			options = paste(options," -S")
			if(is.character(S) || is.numeric(S)) {
			options = paste(options, " ", S)
			}	
			}
			 
			if (!is.null(r)) {
			options = paste(options," -r")
			if(is.character(r) || is.numeric(r)) {
			options = paste(options, " ", r)
			}	
			}
			 
			if (!is.null(nobuf)) {
			options = paste(options," -nobuf")
			if(is.character(nobuf) || is.numeric(nobuf)) {
			options = paste(options, " ", nobuf)
			}	
			}
			 
			if (!is.null(o)) {
			options = paste(options," -o")
			if(is.character(o) || is.numeric(o)) {
			options = paste(options, " ", o)
			}	
			}
			 
			if (!is.null(nonamecheck)) {
			options = paste(options," -nonamecheck")
			if(is.character(nonamecheck) || is.numeric(nonamecheck)) {
			options = paste(options, " ", nonamecheck)
			}	
			}
			 
			if (!is.null(iobuf)) {
			options = paste(options," -iobuf")
			if(is.character(iobuf) || is.numeric(iobuf)) {
			options = paste(options, " ", iobuf)
			}	
			}
			 
			if (!is.null(split)) {
			options = paste(options," -split")
			if(is.character(split) || is.numeric(split)) {
			options = paste(options, " ", split)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste0(getOption("bedtools.path", default="."), "/bedtools map ", options, " -a ", a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("aTable")) { 
		file.remove (aTable)
		} 
 
		if(exists("bTable")) { 
		file.remove (bTable)
		} 
