#' Convert BAM alignments to FASTQ files. 
#' 
#' @param i <BAM>
#' @param fq <FQ>
#' @param fq2 FASTQ for second end.  Used if BAM contains paired-end data.
#' BAM should be sorted by query name is creating paired FASTQ.
#' 
#' @param tags Create FASTQ based on the mate info
#' in the BAM R2 and Q2 tags.
#' 
bamtofastq <- function(i, fq, fq2 = NULL, tags = NULL)
{ 
	options = "" 
	if (is.null(fq2) == FALSE) 
 	{ 
	 options = paste(options," -fq2", sep="")
	}
	if (is.null(tags) == FALSE) 
 	{ 
	 options = paste(options," -tags", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools bamtofastq ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 