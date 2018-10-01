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
	options = "" 
	if (is.null(bedpe) == FALSE) 
 	{ 
	 options = paste(options," -bedpe", sep="")
	}
	if (is.null(mate1) == FALSE) 
 	{ 
	 options = paste(options," -mate1", sep="")
	}
	if (is.null(bed12) == FALSE) 
 	{ 
	 options = paste(options," -bed12", sep="")
	}
	if (is.null(split) == FALSE) 
 	{ 
	 options = paste(options," -split", sep="")
	}
	if (is.null(splitD) == FALSE) 
 	{ 
	 options = paste(options," -splitD", sep="")
	}
	if (is.null(ed) == FALSE) 
 	{ 
	 options = paste(options," -ed", sep="")
	}
	if (is.null(tag) == FALSE) 
 	{ 
	 options = paste(options," -tag", sep="")
	}
	if (is.null(color) == FALSE) 
 	{ 
	 options = paste(options," -color", sep="")
	}
	if (is.null(cigar) == FALSE) 
 	{ 
	 options = paste(options," -cigar", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools bamtobed ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 