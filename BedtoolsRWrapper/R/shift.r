#' Shift each feature by requested number of base pairs.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome> [
#' @param s <int> or (
#' @param p and
#' @param m)] 
#' @param s Shift the BED/GFF/VCF entry -s base pairs.
#' - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param p Shift features on the + strand by -p base pairs.
#' - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param m Shift features on the - strand by -m base pairs.
#' - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param pct Define -s, -m and -p as a fraction of the feature's length.
#' E.g. if used on a 1000bp feature, -s 0.50, 
#' will shift the feature 500 bp "upstream".  Default = false.
#' 
#' @param header Print the header from the input file prior to results.
#' 
shift <- function(i, g, s, p, m)], s = NULL, p = NULL, m = NULL, pct = NULL, header = NULL)
{ 
	options = "" 
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
	}
	if (is.null(p) == FALSE) 
 	{ 
	 options = paste(options," -p", sep="")
	}
	if (is.null(m) == FALSE) 
 	{ 
	 options = paste(options," -m", sep="")
	}
	if (is.null(pct) == FALSE) 
 	{ 
	 options = paste(options," -pct", sep="")
	}
	if (is.null(header) == FALSE) 
 	{ 
	 options = paste(options," -header", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools shift ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 