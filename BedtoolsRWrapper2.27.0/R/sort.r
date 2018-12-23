#' Sorts a feature file in various and useful ways.
#' 
#' @param i <bed/gff/vcf>
#' @param sizeA   Sort by feature size in ascending order.
#' 
#' @param sizeD   Sort by feature size in descending order.
#' 
#' @param chrThenSizeA  Sort by chrom (asc), then feature size (asc).
#' 
#' @param chrThenSizeD  Sort by chrom (asc), then feature size (desc).
#' 
#' @param chrThenScoreA  Sort by chrom (asc), then score (asc).
#' 
#' @param chrThenScoreD  Sort by chrom (asc), then score (desc).
#' 
#' @param g Sort according to the chromosomes declared in "genome.txt"
#' 
#' @param faidx Sort according to the chromosomes declared in "names.txt"
#' 
#' @param header Print the header from the A file prior to results.
#' 
sort <- function(i, sizeA = NULL, sizeD = NULL, chrThenSizeA = NULL, chrThenSizeD = NULL, chrThenScoreA = NULL, chrThenScoreD = NULL, g = NULL, faidx = NULL, header = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
		options = "" 
 
			if (!is.null(sizeA)) {
			options = paste(options," -sizeA")
			if(is.character(sizeA) || is.numeric(sizeA)) {
			options = paste(options, " ", sizeA)
			}	
			}
			 
			if (!is.null(sizeD)) {
			options = paste(options," -sizeD")
			if(is.character(sizeD) || is.numeric(sizeD)) {
			options = paste(options, " ", sizeD)
			}	
			}
			 
			if (!is.null(chrThenSizeA)) {
			options = paste(options," -chrThenSizeA")
			if(is.character(chrThenSizeA) || is.numeric(chrThenSizeA)) {
			options = paste(options, " ", chrThenSizeA)
			}	
			}
			 
			if (!is.null(chrThenSizeD)) {
			options = paste(options," -chrThenSizeD")
			if(is.character(chrThenSizeD) || is.numeric(chrThenSizeD)) {
			options = paste(options, " ", chrThenSizeD)
			}	
			}
			 
			if (!is.null(chrThenScoreA)) {
			options = paste(options," -chrThenScoreA")
			if(is.character(chrThenScoreA) || is.numeric(chrThenScoreA)) {
			options = paste(options, " ", chrThenScoreA)
			}	
			}
			 
			if (!is.null(chrThenScoreD)) {
			options = paste(options," -chrThenScoreD")
			if(is.character(chrThenScoreD) || is.numeric(chrThenScoreD)) {
			options = paste(options, " ", chrThenScoreD)
			}	
			}
			 
			if (!is.null(g)) {
			options = paste(options," -g")
			if(is.character(g) || is.numeric(g)) {
			options = paste(options, " ", g)
			}	
			}
			 
			if (!is.null(faidx)) {
			options = paste(options," -faidx")
			if(is.character(faidx) || is.numeric(faidx)) {
			options = paste(options, " ", faidx)
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
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools2/bin/bedtools sort ", options, " -i ", i, " > ", tempfile) 
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
