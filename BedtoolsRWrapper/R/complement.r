#' Returns the base pair complement of a feature file.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
complement <- function(i, g, )
{ 
	options = "" 

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools complement ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 