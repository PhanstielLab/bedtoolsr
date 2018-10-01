#' Clusters overlapping/nearby BED/GFF/VCF intervals.
#' 
#' @param i <bed/gff/vcf>
#' @param s Force strandedness.  That is, only merge features
#' that are the same strand.
#' - By default, merging is done without respect to strand.
#' 
#' @param d Maximum distance between features allowed for features
#' to be merged.
#' - Def. 0. That is, overlapping & book-ended features are merged.
#' - (INTEGER)
#' 
cluster
 <- function(i, s = NULL, d = NULL)
{ 
	options = "" 
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
	}
	if (is.null(d) == FALSE) 
 	{ 
	 options = paste(options," -d", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools cluster
 ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 