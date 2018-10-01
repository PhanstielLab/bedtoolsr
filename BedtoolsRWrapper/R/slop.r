#' Add requested base pairs of "slop" to each feature.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome> [
#' @param b <int> or (
#' @param l and
#' @param r)] 
#' @param b Increase the BED/GFF/VCF entry -b base pairs in each direction.
#' - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param l The number of base pairs to subtract from the start coordinate.
#' - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param r The number of base pairs to add to the end coordinate.
#' - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param s Define -l and -r based on strand.
#' E.g. if used, -l 500 for a negative-stranded feature, 
#' it will add 500 bp downstream.  Default = false.
#' 
#' @param pct Define -l and -r as a fraction of the feature's length.
#' E.g. if used on a 1000bp feature, -l 0.50, 
#' will add 500 bp "upstream".  Default = false.
#' 
#' @param header Print the header from the input file prior to results.
#' 
slop <- function(i, g, b, l, r)], b = NULL, l = NULL, r = NULL, s = NULL, pct = NULL, header = NULL)
{ 
	options = "" 
	if (is.null(b) == FALSE) 
 	{ 
	 options = paste(options," -b", sep="")
	}
	if (is.null(l) == FALSE) 
 	{ 
	 options = paste(options," -l", sep="")
	}
	if (is.null(r) == FALSE) 
 	{ 
	 options = paste(options," -r", sep="")
	}
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
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
	cmd = paste("bedtools slop ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 