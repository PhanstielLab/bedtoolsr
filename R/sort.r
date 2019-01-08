#' Sorts a feature file in various and useful ways.
#' 
#' @param i <bed/gff/vcf>
#' @param faidx Sort according to the chromosomes declared in "names.txt"
#' 
#' @param chrThenScoreD  Sort by chrom (asc), then score (desc).
#' 
#' @param g Sort according to the chromosomes declared in "genome.txt"
#' 
#' @param chrThenScoreA  Sort by chrom (asc), then score (asc).
#' 
#' @param header Print the header from the A file prior to results.
#' 
#' @param sizeD   Sort by feature size in descending order.
#' 
#' @param chrThenSizeD  Sort by chrom (asc), then feature size (desc).
#' 
#' @param chrThenSizeA  Sort by chrom (asc), then feature size (asc).
#' 
#' @param sizeA   Sort by feature size in ascending order.
#' 
sort <- function(i, faidx = NULL, chrThenScoreD = NULL, g = NULL, chrThenScoreA = NULL, header = NULL, sizeD = NULL, chrThenSizeD = NULL, chrThenSizeA = NULL, sizeA = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
		options = "" 
 
			if (!is.null(faidx)) {
			options = paste(options," -faidx")
			if(is.character(faidx) || is.numeric(faidx)) {
			options = paste(options, " ", faidx)
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
			 
			if (!is.null(chrThenScoreA)) {
			options = paste(options," -chrThenScoreA")
			if(is.character(chrThenScoreA) || is.numeric(chrThenScoreA)) {
			options = paste(options, " ", chrThenScoreA)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(sizeD)) {
			options = paste(options," -sizeD")
			if(is.character(sizeD) || is.numeric(sizeD)) {
			options = paste(options, " ", sizeD)
			}	
			}
			 
			if (!is.null(chrThenSizeD)) {
			options = paste(options," -chrThenSizeD")
			if(is.character(chrThenSizeD) || is.numeric(chrThenSizeD)) {
			options = paste(options, " ", chrThenSizeD)
			}	
			}
			 
			if (!is.null(chrThenSizeA)) {
			options = paste(options," -chrThenSizeA")
			if(is.character(chrThenSizeA) || is.numeric(chrThenSizeA)) {
			options = paste(options, " ", chrThenSizeA)
			}	
			}
			 
			if (!is.null(sizeA)) {
			options = paste(options," -sizeA")
			if(is.character(sizeA) || is.numeric(sizeA)) {
			options = paste(options, " ", sizeA)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste(getOption("bedtools.path"), "bedtools sort ", options, " -i ", i, " > ", tempfile) 
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
