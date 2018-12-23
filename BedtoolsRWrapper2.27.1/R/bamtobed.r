#' Converts BAM alignments to BED6 or BEDPE format.
#' 
#' @param i <bam>
#' @param bedpe Write BEDPE format.
#' - Requires BAM to be grouped or sorted by query.
#' 
#' @param mate1 When writing BEDPE (-bedpe) format, 
#' always report mate one as the first BEDPE "block".
#' 
#' @param bed12 Write "blocked" BED format (aka "BED12"). Forces -split.
#' http://genome-test.cse.ucsc.edu/FAQ/FAQformat#format1
#' 
#' @param split Report "split" BAM alignments as separate BED entries.
#' Splits only on N CIGAR operations.
#' 
#' @param splitD Split alignments based on N and D CIGAR operators.
#' Forces -split.
#' 
#' @param ed Use BAM edit distance (NM tag) for BED score.
#' - Default for BED is to use mapping quality.
#' - Default for BEDPE is to use the minimum of
#'   the two mapping qualities for the pair.
#' - When -ed is used with -bedpe, the total edit
#'   distance from the two mates is reported.
#' 
#' @param tag Use other NUMERIC BAM alignment tag for BED score.
#' - Default for BED is to use mapping quality.
#'   Disallowed with BEDPE output.
#' 
#' @param color An R,G,B string for the color used with BED12 format.
#' Default is (255,0,0).
#' 
#' @param cigar Add the CIGAR string to the BED entry as a 7th column.
#' 
bamtobed <- function(i, bedpe = NULL, mate1 = NULL, bed12 = NULL, split = NULL, splitD = NULL, ed = NULL, tag = NULL, color = NULL, cigar = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
		options = "" 
 
			if (!is.null(bedpe)) {
			options = paste(options," -bedpe")
			if(is.character(bedpe) || is.numeric(bedpe)) {
			options = paste(options, " ", bedpe)
			}	
			}
			 
			if (!is.null(mate1)) {
			options = paste(options," -mate1")
			if(is.character(mate1) || is.numeric(mate1)) {
			options = paste(options, " ", mate1)
			}	
			}
			 
			if (!is.null(bed12)) {
			options = paste(options," -bed12")
			if(is.character(bed12) || is.numeric(bed12)) {
			options = paste(options, " ", bed12)
			}	
			}
			 
			if (!is.null(split)) {
			options = paste(options," -split")
			if(is.character(split) || is.numeric(split)) {
			options = paste(options, " ", split)
			}	
			}
			 
			if (!is.null(splitD)) {
			options = paste(options," -splitD")
			if(is.character(splitD) || is.numeric(splitD)) {
			options = paste(options, " ", splitD)
			}	
			}
			 
			if (!is.null(ed)) {
			options = paste(options," -ed")
			if(is.character(ed) || is.numeric(ed)) {
			options = paste(options, " ", ed)
			}	
			}
			 
			if (!is.null(tag)) {
			options = paste(options," -tag")
			if(is.character(tag) || is.numeric(tag)) {
			options = paste(options, " ", tag)
			}	
			}
			 
			if (!is.null(color)) {
			options = paste(options," -color")
			if(is.character(color) || is.numeric(color)) {
			options = paste(options, " ", color)
			}	
			}
			 
			if (!is.null(cigar)) {
			options = paste(options," -cigar")
			if(is.character(cigar) || is.numeric(cigar)) {
			options = paste(options, " ", cigar)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools271/bin/bedtools bamtobed ", options, " -i ", i, " > ", tempfile) 
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
