#' Merges overlapping BED/GFF/VCF entries into a single interval.
#' 
#' @param i <bed/gff/vcf>
#' @param s Force strandedness.  That is, only merge features
#' that are on the same strand.
#' - By default, merging is done without respect to strand.
#' 
#' @param S Force merge for one specific strand only.
#' Follow with + or - to force merge from only
#' the forward or reverse strand, respectively.
#' - By default, merging is done without respect to strand.
#' 
#' @param d Maximum distance between features allowed for features
#' to be merged.
#' - Def. 0. That is, overlapping & book-ended features are merged.
#' - (INTEGER)
#' - Note: negative values enforce the number of b.p. required for overlap.
#' 
#' @param c Specify columns from the B file to map onto intervals in A.
#' Default: 5.
#' Multiple columns can be specified in a comma-delimited list.
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
#' @param delim Specify a custom delimiter for the collapse operations.
#' - Example: -delim "|"
#' - Default: ",".
#' 
#' @param prec Sets the decimal precision for output (Default: 5)
#' 
#' @param bed If using BAM input, write output as BED.
#' 
#' @param header Print the header from the A file prior to results.
#' 
#' @param nobuf Disable buffered output. Using this option will cause each line
#' of output to be printed as it is generated, rather than saved
#' in a buffer. This will make printing large output files 
#' noticeably slower, but can be useful in conjunction with
#' other software tools and scripts that need to process one
#' line of bedtools output at a time.
#' 
#' @param iobuf Specify amount of memory to use for input buffer.
#' Takes an integer argument. Optional suffixes K/M/G supported.
#' Note: currently has no effect with compressed files.
#' 
merge <- function(i, s = NULL, S = NULL, d = NULL, c = NULL, o = NULL, delim = NULL, prec = NULL, bed = NULL, header = NULL, nobuf = NULL, iobuf = NULL)
{ 
	options = "" 
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
	}
	if (is.null(S) == FALSE) 
 	{ 
	 options = paste(options," -S", sep="")
	}
	if (is.null(d) == FALSE) 
 	{ 
	 options = paste(options," -d", sep="")
	}
	if (is.null(c) == FALSE) 
 	{ 
	 options = paste(options," -c", sep="")
	}
	if (is.null(o) == FALSE) 
 	{ 
	 options = paste(options," -o", sep="")
	}
	if (is.null(delim) == FALSE) 
 	{ 
	 options = paste(options," -delim", sep="")
	}
	if (is.null(prec) == FALSE) 
 	{ 
	 options = paste(options," -prec", sep="")
	}
	if (is.null(bed) == FALSE) 
 	{ 
	 options = paste(options," -bed", sep="")
	}
	if (is.null(header) == FALSE) 
 	{ 
	 options = paste(options," -header", sep="")
	}
	if (is.null(nobuf) == FALSE) 
 	{ 
	 options = paste(options," -nobuf", sep="")
	}
	if (is.null(iobuf) == FALSE) 
 	{ 
	 options = paste(options," -iobuf", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools merge ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 