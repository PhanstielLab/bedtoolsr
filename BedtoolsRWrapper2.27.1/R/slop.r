#' Add requested base pairs of "slop" to each feature.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
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
slop <- function(i, g, b = NULL, l = NULL, r = NULL, s = NULL, pct = NULL, header = NULL)
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
 
			if (!is.null(b)) {
			options = paste(options," -b")
			if(is.character(b) || is.numeric(b)) {
			options = paste(options, " ", b)
			}	
			}
			 
			if (!is.null(l)) {
			options = paste(options," -l")
			if(is.character(l) || is.numeric(l)) {
			options = paste(options, " ", l)
			}	
			}
			 
			if (!is.null(r)) {
			options = paste(options," -r")
			if(is.character(r) || is.numeric(r)) {
			options = paste(options, " ", r)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			 
			if (!is.null(pct)) {
			options = paste(options," -pct")
			if(is.character(pct) || is.numeric(pct)) {
			options = paste(options, " ", pct)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools271/bin/bedtools slop ", options, " -i ", i, " -g ", g, " > ", tempfile) 
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
