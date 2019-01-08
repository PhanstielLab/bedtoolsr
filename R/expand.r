#' Replicate lines in a file based on columns of comma-separated values.
#' 
#' @param c 
#' @param i Input file. Assumes "stdin" if omitted.
#' 
expand <- function(c, i = NULL)
{ 

			if (!is.character(c) && !is.numeric(c)) {
			cTable = "~/Desktop/cTable.txt"
			write.table(c, cTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			c=cTable } 
			
		options = "" 
 
			if (!is.null(i)) {
			options = paste(options," -i")
			if(is.character(i) || is.numeric(i)) {
			options = paste(options, " ", i)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste0(getOption("bedtools.path", default="."), "/bedtools expand ", options, " -c ", c, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("cTable")) { 
		file.remove (cTable)
		} 
