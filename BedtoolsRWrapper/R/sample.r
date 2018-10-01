#' Take sample of input file(s) using reservoir sampling algorithm.
#' 
#' @param i <bed/gff/vcf/bam>
#' WARNING:	The current sample algorithm will hold all requested sample records in memory prior to output.
#' The user must ensure that there is adequate memory for this.
#' @param n The number of records to generate.
#' - Default = 1,000,000.
#' - (INTEGER)
#' 
#' @param seed Supply an integer seed for the shuffling.
#' - By default, the seed is chosen automatically.
#' - (INTEGER)
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
#' @param s Require same strandedness.  That is, only give records
#' that have the same strand. Use '-s forward' or '-s reverse'
#' for forward or reverse strand records, respectively.
#' - By default, records are reported without respect to strand.
#' 
#' @param header Print the header from the A file prior to results.
#' 
#' @param bed If using BAM input, write output as BED.
#' 
#' @param nobuf Disable buffered output. Using this option will cause each line
#' of output to be printed as it is generated, rather than saved
#' in a buffer. This will make printing large output files 
#' noticeably slower, but can be useful in conjunction with
#' other software tools and scripts that need to process one
#' line of bedtools output at a time.
#' 
#' @param iobuf Specify amount of memory to use for input buffer.
#' Takes an integer argument. Optional suffixes K/M/G supported.
#' Note: currently has no effect with compressed files.
#' 
sample <- function(i, n = NULL, seed = NULL, ubam = NULL, s = NULL, header = NULL, bed = NULL, nobuf = NULL, iobuf = NULL)
{ 
	options = "" 
	if (is.null(n) == FALSE) 
 	{ 
	 options = paste(options," -n", sep="")
	}
	if (is.null(seed) == FALSE) 
 	{ 
	 options = paste(options," -seed", sep="")
	}
	if (is.null(ubam) == FALSE) 
 	{ 
	 options = paste(options," -ubam", sep="")
	}
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
	}
	if (is.null(header) == FALSE) 
 	{ 
	 options = paste(options," -header", sep="")
	}
	if (is.null(bed) == FALSE) 
 	{ 
	 options = paste(options," -bed", sep="")
	}
	if (is.null(nobuf) == FALSE) 
 	{ 
	 options = paste(options," -nobuf", sep="")
	}
	if (is.null(iobuf) == FALSE) 
 	{ 
	 options = paste(options," -iobuf", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools sample ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 