#' Calculate the relative distance distribution b/w two feature files.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param detail Instead of a summary, report the relative   distance for each interval in A
#' 
reldist
 <- function(a, b, detail = NULL)
{ 
	options = "" 
	if (is.null(detail) == FALSE) 
 	{ 
	 options = paste(options," -detail", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools reldist
 ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 