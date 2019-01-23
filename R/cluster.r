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
cluster <- function(i, s = NULL, d = NULL)
{ 

            if (!is.character(i) && !is.numeric(i)) {
            iTable = paste0(tempdir(), "/iTable.txt")
            write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
            i=iTable } 
            
		options = "" 
 
            if (!is.null(s)) {
            options = paste(options," -s")
            if(is.character(s) || is.numeric(s)) {
            options = paste(options, " ", s)
            }   
            }
             
            if (!is.null(d)) {
            options = paste(options," -d")
            if(is.character(d) || is.numeric(d)) {
            options = paste(options, " ", d)
            }   
            }
            
	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools cluster ", options, " -i ", i, " > ", tempfile) 
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
