#' Extract DNA sequences from a fasta file based on feature coordinates.
#' 
#' @param fi <fasta>
#' @param bed <bed/gff/vcf>
#' @param fi Input FASTA file
#' 
#' @param fo Output file (opt., default is STDOUT
#' 
#' @param bed BED/GFF/VCF file of ranges to extract from -fi
#' 
#' @param name Use the name field for the FASTA header
#' 
#' @param name+ Use the name field and coordinates for the FASTA header
#' 
#' @param split given BED12 fmt., extract and concatenate the sequences
#' from the BED "blocks" (e.g., exons)
#' 
#' @param tab Write output in TAB delimited format.
#' - Default is FASTA format.
#' 
#' @param s Force strandedness. If the feature occupies the antisense,
#' strand, the sequence will be reverse complemented.
#' - By default, strand information is ignored.
#' 
#' @param fullHeader Use full fasta header.
#' - By default, only the word before the first space or tab 
#' is used.
#' 
getfasta <- function(fi, bed, fi = NULL, fo = NULL, bed = NULL, name = NULL, name+ = NULL, split = NULL, tab = NULL, s = NULL, fullHeader = NULL)
{ 
	options = "" 
	if (is.null(fi) == FALSE) 
 	{ 
	 options = paste(options," -fi", sep="")
	}
	if (is.null(fo) == FALSE) 
 	{ 
	 options = paste(options," -fo", sep="")
	}
	if (is.null(bed) == FALSE) 
 	{ 
	 options = paste(options," -bed", sep="")
	}
	if (is.null(name) == FALSE) 
 	{ 
	 options = paste(options," -name", sep="")
	}
	if (is.null(name+) == FALSE) 
 	{ 
	 options = paste(options," -name+", sep="")
	}
	if (is.null(split) == FALSE) 
 	{ 
	 options = paste(options," -split", sep="")
	}
	if (is.null(tab) == FALSE) 
 	{ 
	 options = paste(options," -tab", sep="")
	}
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
	}
	if (is.null(fullHeader) == FALSE) 
 	{ 
	 options = paste(options," -fullHeader", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools getfasta ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 