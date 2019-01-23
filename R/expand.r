#' Replicate lines in a file based on columns of comma-separated values.
#' 
#' @param c 
#' @param i Input file. Assumes "stdin" if omitted.
#' 
expand <- function(c, i = NULL)
{ 

            if (!is.character(c) && !is.numeric(c)) {
            cTable = paste0(tempdir(), "/cTable.txt")
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
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools expand ", options, " -c ", c, " > ", tempfile) 
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
