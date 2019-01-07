#' Profiles the nucleotide content of intervals in a fasta file.
#' 
#' @param fi <fasta>
#' @param bed <bed/gff/vcf>
#' @param C Ignore case when matching -pattern. By defaulty, case matters.
#' 
#' @param seq Print the extracted sequence
#' 
#' @param pattern Report the number of times a user-defined sequence
#'  is observed (case-sensitive).
#' 
#' @param fullHeader Use full fasta header.
#' - By default, only the word before the first space or tab is used.
#' 
#' @param s Profile the sequence according to strand.
#' 
nuc <- function(fi, bed, C = NULL, seq = NULL, pattern = NULL, fullHeader = NULL, s = NULL)
{ 

			if (!is.character(fi) && !is.numeric(fi)) {
			fiTable = "~/Desktop/fiTable.txt"
			write.table(fi, fiTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			fi=fiTable } 
			
			if (!is.character(bed) && !is.numeric(bed)) {
			bedTable = "~/Desktop/bedTable.txt"
			write.table(bed, bedTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			bed=bedTable } 
			
		options = "" 
 
			if (!is.null(C)) {
			options = paste(options," -C")
			if(is.character(C) || is.numeric(C)) {
			options = paste(options, " ", C)
			}	
			}
			 
			if (!is.null(seq)) {
			options = paste(options," -seq")
			if(is.character(seq) || is.numeric(seq)) {
			options = paste(options, " ", seq)
			}	
			}
			 
			if (!is.null(pattern)) {
			options = paste(options," -pattern")
			if(is.character(pattern) || is.numeric(pattern)) {
			options = paste(options, " ", pattern)
			}	
			}
			 
			if (!is.null(fullHeader)) {
			options = paste(options," -fullHeader")
			if(is.character(fullHeader) || is.numeric(fullHeader)) {
			options = paste(options, " ", fullHeader)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste(getOption("bedtools.path"), " bedtools nuc ", options, " -fi ", fi, " -bed ", bed, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("fiTable")) { 
		file.remove (fiTable)
		} 
 
		if(exists("bedTable")) { 
		file.remove (bedTable)
		} 
