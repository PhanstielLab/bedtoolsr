#' Creates HTML links to an UCSC Genome Browser from a feature file.
#' 
#' @param i <bed/gff/vcf> > out.html
#' @param base The browser basename.  Default: http://genome.ucsc.edu 
#' 
#' @param org The organism. Default: human
#' 
#' @param db The build.  Default: hg18
#' 
links <- function(i, base = NULL, org = NULL, db = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
		options = "" 
 
			if (!is.null(base)) {
			options = paste(options," -base")
			if(is.character(base) || is.numeric(base)) {
			options = paste(options, " ", base)
			}	
			}
			 
			if (!is.null(org)) {
			options = paste(options," -org")
			if(is.character(org) || is.numeric(org)) {
			options = paste(options, " ", org)
			}	
			}
			 
			if (!is.null(db)) {
			options = paste(options," -db")
			if(is.character(db) || is.numeric(db)) {
			options = paste(options, " ", db)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools2/bin/bedtools links ", options, " -i ", i, " > ", tempfile) 
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
