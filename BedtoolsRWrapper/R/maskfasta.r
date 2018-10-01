#' Mask a fasta file based on feature coordinates.
#' 
#' @param fi <fasta>
#' @param fo <fasta>
#' @param bed <bed/gff/vcf>
#' @param fi  Input FASTA file
#' 
#' @param bed  BED/GFF/VCF file of ranges to mask in -fi
#' 
#' @param fo  Output FASTA file
#' 
#' @param soft  Enforce "soft" masking.
#'  Mask with lower-case bases, instead of masking with Ns.
#' 
#' @param mc  Replace masking character.
#'  Use another character, instead of masking with Ns.
#' 
#' @param fullHeader Use full fasta header.
#'  By default, only the word before the first space or tab
#'  is used.
#' 
maskfasta <- function(fi, fo, bed, fi = NULL, bed = NULL, fo = NULL, soft = NULL, mc = NULL, fullHeader = NULL)
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
	if (is.null(fo) == FALSE) 
 	{ 
	 options = paste(options," -fo", sep="")
	}
	if (is.null(soft) == FALSE) 
 	{ 
	 options = paste(options," -soft", sep="")
	}
	if (is.null(mc) == FALSE) 
 	{ 
	 options = paste(options," -mc", sep="")
	}
	if (is.null(fullHeader) == FALSE) 
 	{ 
	 options = paste(options," -fullHeader", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools maskfasta ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 