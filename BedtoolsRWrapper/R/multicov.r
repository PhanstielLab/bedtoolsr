#' Counts sequence coverage for multiple bams at specific loci.
#' 
#' @param bams aln.1.bam aln.2.bam ... aln.n.bam
#' @param bed <bed/gff/vcf>
#' @param bams The bam files.
#' 
#' @param bed The bed file.
#' 
#' @param split Treat "split" BAM or BED12 entries as distinct BED intervals.
#' 
#' @param s Require same strandedness.  That is, only report hits in B
#' that overlap A on the _same_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param S Require different strandedness.  That is, only report hits in B
#' that overlap A on the _opposite_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param f Minimum overlap required as a fraction of each A.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param r Require that the fraction overlap be reciprocal for each A and B.
#' - In other words, if -f is 0.90 and -r is used, this requires
#'   that B overlap 90% of A and A _also_ overlaps 90% of B.
#' 
#' @param q Minimum mapping quality allowed. Default is 0.
#' 
#' @param D Include duplicate reads.  Default counts non-duplicates only
#' 
#' @param F Include failed-QC reads.  Default counts pass-QC reads only
#' 
#' @param p Only count proper pairs.  Default counts all alignments with
#' MAPQ > -q argument, regardless of the BAM FLAG field.
#' 
multicov <- function(bams, bed, bams = NULL, bed = NULL, split = NULL, s = NULL, S = NULL, f = NULL, r = NULL, q = NULL, D = NULL, F = NULL, p = NULL)
{ 
	options = "" 
	if (is.null(bams) == FALSE) 
 	{ 
	 options = paste(options," -bams", sep="")
	}
	if (is.null(bed) == FALSE) 
 	{ 
	 options = paste(options," -bed", sep="")
	}
	if (is.null(split) == FALSE) 
 	{ 
	 options = paste(options," -split", sep="")
	}
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
	}
	if (is.null(S) == FALSE) 
 	{ 
	 options = paste(options," -S", sep="")
	}
	if (is.null(f) == FALSE) 
 	{ 
	 options = paste(options," -f", sep="")
	}
	if (is.null(r) == FALSE) 
 	{ 
	 options = paste(options," -r", sep="")
	}
	if (is.null(q) == FALSE) 
 	{ 
	 options = paste(options," -q", sep="")
	}
	if (is.null(D) == FALSE) 
 	{ 
	 options = paste(options," -D", sep="")
	}
	if (is.null(F) == FALSE) 
 	{ 
	 options = paste(options," -F", sep="")
	}
	if (is.null(p) == FALSE) 
 	{ 
	 options = paste(options," -p", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools multicov ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 