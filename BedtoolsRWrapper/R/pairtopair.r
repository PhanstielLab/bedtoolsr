#' Report overlaps between two paired-end BED files (BEDPE).
#' 
#' @param a <BEDPE>
#' @param b <BEDPE>
#' @param f Minimum overlap required as fraction of A (e.g. 0.05).
#' Default is 1E-9 (effectively 1bp).
#' 
#' @param type  Approach to reporting overlaps between A and B.
#' neither Report overlaps if neither end of A overlaps B.
#' either Report overlaps if either ends of A overlap B.
#' both Report overlaps if both ends of A overlap B.
#' notboth Report overlaps if one or neither of A's overlap B.
#' - Default = both.
#' 
#' @param slop  The amount of slop (in b.p.). to be added to each footprint of A.
#' *Note*: Slop is subtracted from start1 and start2
#'  and added to end1 and end2.
#' - Default = 0.
#' 
#' @param ss Add slop based to each BEDPE footprint based on strand.
#' - If strand is "+", slop is only added to the end coordinates.
#' - If strand is "-", slop is only added to the start coordinates.
#' - By default, slop is added in both directions.
#' 
#' @param is Ignore strands when searching for overlaps.
#' - By default, strands are enforced.
#' 
#' @param rdn Require the hits to have different names (i.e. avoid self-hits).
#' - By default, same names are allowed.
#' 
pairtopair <- function(a, b, f = NULL, type  = NULL, slop  = NULL, ss = NULL, is = NULL, rdn = NULL)
{ 
	options = "" 
	if (is.null(f) == FALSE) 
 	{ 
	 options = paste(options," -f", sep="")
	}
	if (is.null(type ) == FALSE) 
 	{ 
	 options = paste(options," -type ", sep="")
	}
	if (is.null(slop ) == FALSE) 
 	{ 
	 options = paste(options," -slop ", sep="")
	}
	if (is.null(ss) == FALSE) 
 	{ 
	 options = paste(options," -ss", sep="")
	}
	if (is.null(is) == FALSE) 
 	{ 
	 options = paste(options," -is", sep="")
	}
	if (is.null(rdn) == FALSE) 
 	{ 
	 options = paste(options," -rdn", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools pairtopair ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 