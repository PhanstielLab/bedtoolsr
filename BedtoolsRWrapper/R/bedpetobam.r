#' Converts feature records to BAM format.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param mapq Set the mappinq quality for the BAM records.
#' (INT) Default: 255
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
bedpetobam <- function(i, g, mapq = NULL, ubam = NULL)
{ 
	options = "" 
	if (is.null(mapq) == FALSE) 
 	{ 
	 options = paste(options," -mapq", sep="")
	}
	if (is.null(ubam) == FALSE) 
 	{ 
	 options = paste(options," -ubam", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools bedpetobam ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 