#' Replicate lines in a file based on columns of comma-separated values.
#' 
#' @param c [COLS]
#' @param i Input file. Assumes "stdin" if omitted.
#' 
#' @param c  Specify the column (1-based) that should be summarized.
#' - Required.
#' 
expand <- function(c, i = NULL, c  = NULL)
{ 
	options = "" 
	if (is.null(i) == FALSE) 
 	{ 
	 options = paste(options," -i", sep="")
	}
	if (is.null(c ) == FALSE) 
 	{ 
	 options = paste(options," -c ", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools expand ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 