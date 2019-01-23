#' Calculate the relative distance distribution b/w two feature files.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param detail Instead of a summary, report the relative   distance for each interval in A
#' 
reldist <- function(a, b, detail = NULL)
{ 

            if (!is.character(a) && !is.numeric(a)) {
            aTable = paste0(tempdir(), "/aTable.txt")
            write.table(a, aTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
            a=aTable } 
            
            if (!is.character(b) && !is.numeric(b)) {
            bTable = paste0(tempdir(), "/bTable.txt")
            write.table(b, bTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
            b=bTable } 
            
		options = "" 
 
            if (!is.null(detail)) {
            options = paste(options," -detail")
            if(is.character(detail) || is.numeric(detail)) {
            options = paste(options, " ", detail)
            }   
            }
            
	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools reldist ", options, " -a ", a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
        if (file.exists(tempfile)){ 
        file.remove(tempfile) 
        }
        return (results)
        }
         
        if(exists("aTable")) { 
        file.remove (aTable)
        } 
 
        if(exists("bTable")) { 
        file.remove (bTable)
        } 
