#' Split a Bed file.
#' 
#' @param i <bed>
#' @param n number
#' @param of 
#' @param files 
#' @param i|--input (file) BED input file (req'd).
#' 
#' @param n|--number (int) Number of files to create (req'd).
#' 
#' @param p|--prefix (string) Output BED file prefix.
#' 
#' @param a|--algorithm (string) Algorithm used to split data.
#'  * size (default): uses a heuristic algorithm to group the items
#'   so all files contain the ~ same number of bases
#' * simple : route records such that each split file has
#'   approximately equal records (like Unix split).
#' 
#' @param h|--help  Print help (this screen).
#' 
#' @param v|--version  Print version.
#' 
split
 <- function(i, n, of, files, i|--input (file) = NULL, n|--number (int) = NULL, p|--prefix (string) = NULL, a|--algorithm (string) Algorithm used to split data.
 = NULL, h|--help = NULL, v|--version = NULL)
{ 
	options = "" 
	if (is.null(i|--input (file)) == FALSE) 
 	{ 
	 options = paste(options," -i|--input (file)", sep="")
	}
	if (is.null(n|--number (int)) == FALSE) 
 	{ 
	 options = paste(options," -n|--number (int)", sep="")
	}
	if (is.null(p|--prefix (string)) == FALSE) 
 	{ 
	 options = paste(options," -p|--prefix (string)", sep="")
	}
	if (is.null(a|--algorithm (string) Algorithm used to split data.
) == FALSE) 
 	{ 
	 options = paste(options," -a|--algorithm (string) Algorithm used to split data.
", sep="")
	}
	if (is.null(h|--help) == FALSE) 
 	{ 
	 options = paste(options," -h|--help", sep="")
	}
	if (is.null(v|--version) == FALSE) 
 	{ 
	 options = paste(options," -v|--version", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools split
 ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 