#' Creates a batch script to create IGV images 
#' at each interval defined in a BED/GFF/VCF file.
#' 
#' @param i <bed/gff/vcf>
#' @param path The full path to which the IGV snapshots should be written.
#' (STRING) Default: ./
#' 
#' @param sess The full path to an existing IGV session file to be 
#' loaded prior to taking snapshots.
#' (STRING) Default is for no session to be loaded.
#' 
#' @param sort The type of BAM sorting you would like to apply to each image. 
#' Options: base, position, strand, quality, sample, and readGroup
#' Default is to apply no sorting at all.
#' 
#' @param clps Collapse the aligned reads prior to taking a snapshot. 
#' Default is to no collapse.
#' 
#' @param name Use the "name" field (column 4) for each image's filename. 
#' Default is to use the "chr:start-pos.ext".
#' 
#' @param slop Number of flanking base pairs on the left & right of the image.
#' - (INT) Default = 0.
#' 
#' @param img The type of image to be created. 
#' Options: png, eps, svg
#' Default is png.
#' 
igv <- function(i, path = NULL, sess = NULL, sort = NULL, clps = NULL, name = NULL, slop = NULL, img = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
		options = "" 
 
			if (!is.null(path)) {
			options = paste(options," -path")
			if(is.character(path) || is.numeric(path)) {
			options = paste(options, " ", path)
			}	
			}
			 
			if (!is.null(sess)) {
			options = paste(options," -sess")
			if(is.character(sess) || is.numeric(sess)) {
			options = paste(options, " ", sess)
			}	
			}
			 
			if (!is.null(sort)) {
			options = paste(options," -sort")
			if(is.character(sort) || is.numeric(sort)) {
			options = paste(options, " ", sort)
			}	
			}
			 
			if (!is.null(clps)) {
			options = paste(options," -clps")
			if(is.character(clps) || is.numeric(clps)) {
			options = paste(options, " ", clps)
			}	
			}
			 
			if (!is.null(name)) {
			options = paste(options," -name")
			if(is.character(name) || is.numeric(name)) {
			options = paste(options, " ", name)
			}	
			}
			 
			if (!is.null(slop)) {
			options = paste(options," -slop")
			if(is.character(slop) || is.numeric(slop)) {
			options = paste(options, " ", slop)
			}	
			}
			 
			if (!is.null(img)) {
			options = paste(options," -img")
			if(is.character(img) || is.numeric(img)) {
			options = paste(options, " ", img)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools2/bin/bedtools igv ", options, " -i ", i, " > ", tempfile) 
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
