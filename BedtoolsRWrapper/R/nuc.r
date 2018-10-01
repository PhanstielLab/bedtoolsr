#' Profiles the nucleotide content of intervals in a fasta file.
#' 
#' @param fi <fasta>
#' @param bed <bed/gff/vcf>
#' @param fi Input FASTA file
#' 
#' @param bed BED/GFF/VCF file of ranges to extract from -fi
#' 
#' @param s Profile the sequence according to strand.
#' 
#' @param seq Print the extracted sequence
#' 
#' @param pattern Report the number of times a user-defined sequence
#'  is observed (case-sensitive).
#' 
#' @param C Ignore case when matching -pattern. By defaulty, case matters.
#' 
#' @param fullHeader Use full fasta header.
#' - By default, only the word before the first space or tab is used.
#' 
nuc <- function(fi, bed, fi = NULL, bed = NULL, s = NULL, seq = NULL, pattern = NULL, C = NULL, fullHeader = NULL)
{ 
	options = "" 
	if (is.null(fi) == FALSE) 
 	{ 
	 options = paste(options," -fi", sep="")
	}
	if (is.null(bed) == FALSE) 
 	{ 
	 options = paste(options," -bed", sep="")
	}
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
	}
	if (is.null(seq) == FALSE) 
 	{ 
	 options = paste(options," -seq", sep="")
	}
	if (is.null(pattern) == FALSE) 
 	{ 
	 options = paste(options," -pattern", sep="")
	}
	if (is.null(C) == FALSE) 
 	{ 
	 options = paste(options," -C", sep="")
	}
	if (is.null(fullHeader) == FALSE) 
 	{ 
	 options = paste(options," -fullHeader", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools nuc ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 