#' Converts feature records to BAM format.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param mapq Set the mappinq quality for the BAM records.
#' (INT) Default: 255
#' 
#' @param bed12 The BED file is in BED12 format.  The BAM CIGAR
#' string will reflect BED "blocks".
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
bedtobam <- function(i, g, mapq = NULL, bed12 = NULL, ubam = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
			if (!is.character(g) && !is.numeric(g)) {
			gTable = "~/Desktop/gTable.txt"
			write.table(g, gTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			g=gTable } 
			
		options = "" 
 
			if (!is.null(mapq)) {
			options = paste(options," -mapq")
			if(is.character(mapq) || is.numeric(mapq)) {
			options = paste(options, " ", mapq)
			}	
			}
			 
			if (!is.null(bed12)) {
			options = paste(options," -bed12")
			if(is.character(bed12) || is.numeric(bed12)) {
			options = paste(options, " ", bed12)
			}	
			}
			 
			if (!is.null(ubam)) {
			options = paste(options," -ubam")
			if(is.character(ubam) || is.numeric(ubam)) {
			options = paste(options, " ", ubam)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools271/bin/bedtools bedtobam ", options, " -i ", i, " -g ", g, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("iTable")) { 
		file.remove (iTable)
		} 
 
		if(exists("gTable")) { 
		file.remove (gTable)
		} 
