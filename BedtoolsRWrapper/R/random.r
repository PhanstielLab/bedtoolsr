#' Generate random intervals among a genome.
#' 
#' @param g <genome>
#' @param l The length of the intervals to generate.
#' - Default = 100.
#' - (INTEGER)
#' 
#' @param n The number of intervals to generate.
#' - Default = 1,000,000.
#' - (INTEGER)
#' 
#' @param seed Supply an integer seed for the shuffling.
#' - By default, the seed is chosen automatically.
#' - (INTEGER)
#' 
random <- function(g, l = NULL, n = NULL, seed = NULL)
{ 
	options = "" 
	if (is.null(l) == FALSE) 
 	{ 
	 options = paste(options," -l", sep="")
	}
	if (is.null(n) == FALSE) 
 	{ 
	 options = paste(options," -n", sep="")
	}
	if (is.null(seed) == FALSE) 
 	{ 
	 options = paste(options," -seed", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools random ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 