#' Splits BED12 features into discrete BED6 features.
#' 
#' @param i <bed12>
#' @param n Force the score to be the (1-based) block number from the BED12.
#' 
bed12tobed6 <- function(i, n = NULL)
{ 
	options = "" 
	if (is.null(n) == FALSE) 
 	{ 
	 options = paste(options," -n", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools bed12tobed6 ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 