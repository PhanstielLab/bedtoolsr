#' Summarizes a dataset column based upon
#' common column groupings. Akin to the SQL "group by" command.
#' 
#' @param g [group_column(s)]
#' @param c [op_column(s)]
#' @param o [ops]
#' @param i  Input file. Assumes "stdin" if omitted.
#' 
#' @param g -grp  Specify the columns (1-based) for the grouping.
#'  The columns must be comma separated.
#'  - Default: 1,2,3
#' 
#' @param c -opCols Specify the column (1-based) that should be summarized.
#'  - Required.
#' 
#' @param o -ops  Specify the operation that should be applied to opCol.
#'  Valid operations:
#'      sum, count, count_distinct, min, max,
#'      mean, median, mode, antimode,
#'      stdev, sstdev (sample standard dev.),
#'      collapse (i.e., print a comma separated list (duplicates allowed)), 
#'      distinct (i.e., print a comma separated list (NO duplicates allowed)), 
#'      distinct_sort_num (as distinct, but sorted numerically, ascending), 
#'      distinct_sort_num_desc (as distinct, but sorted numerically, descending), 
#'      concat   (i.e., merge values into a single, non-delimited string), 
#'      freqdesc (i.e., print desc. list of values:freq)
#'      freqasc (i.e., print asc. list of values:freq)
#'      first (i.e., print first value)
#'      last (i.e., print last value)
#'  - Default: sum
#' If there is only column, but multiple operations, all operations will be
#' applied on that column. Likewise, if there is only one operation, but
#' multiple columns, that operation will be applied to all columns.
#' Otherwise, the number of columns must match the the number of operations,
#' and will be applied in respective order.
#' E.g., "-c 5,4,6 -o sum,mean,count" will give the sum of column 5,
#' the mean of column 4, and the count of column 6.
#' The order of output columns will match the ordering given in the command.
#' 
#' @param full  Print all columns from input file.  The first line in the group is used.
#'  Default: print only grouped columns.
#' 
#' @param inheader Input file has a header line - the first line will be ignored.
#' 
#' @param outheader Print header line in the output, detailing the column names. 
#'  If the input file has headers (-inheader), the output file
#'  will use the input's column names.
#'  If the input file has no headers, the output file
#'  will use "col_1", "col_2", etc. as the column names.
#' 
#' @param header  same as '-inheader -outheader'
#' 
#' @param ignorecase Group values regardless of upper/lower case.
#' 
#' @param prec Sets the decimal precision for output (Default: 5)
#' 
#' @param delim Specify a custom delimiter for the collapse operations.
#' - Example: -delim "|"
#' - Default: ",".
#' 
groupby <- function(g, c, o, i = NULL, g -grp = NULL, c -opCols = NULL, o -ops = NULL, full = NULL, inheader = NULL, outheader = NULL, header = NULL, ignorecase = NULL, prec = NULL, delim = NULL)
{ 
	options = "" 
	if (is.null(i) == FALSE) 
 	{ 
	 options = paste(options," -i", sep="")
	}
	if (is.null(g -grp) == FALSE) 
 	{ 
	 options = paste(options," -g -grp", sep="")
	}
	if (is.null(c -opCols) == FALSE) 
 	{ 
	 options = paste(options," -c -opCols", sep="")
	}
	if (is.null(o -ops) == FALSE) 
 	{ 
	 options = paste(options," -o -ops", sep="")
	}
	if (is.null(full) == FALSE) 
 	{ 
	 options = paste(options," -full", sep="")
	}
	if (is.null(inheader) == FALSE) 
 	{ 
	 options = paste(options," -inheader", sep="")
	}
	if (is.null(outheader) == FALSE) 
 	{ 
	 options = paste(options," -outheader", sep="")
	}
	if (is.null(header) == FALSE) 
 	{ 
	 options = paste(options," -header", sep="")
	}
	if (is.null(ignorecase) == FALSE) 
 	{ 
	 options = paste(options," -ignorecase", sep="")
	}
	if (is.null(prec) == FALSE) 
 	{ 
	 options = paste(options," -prec", sep="")
	}
	if (is.null(delim) == FALSE) 
 	{ 
	 options = paste(options," -delim", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools groupby ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 