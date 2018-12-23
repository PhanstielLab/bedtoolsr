#' Counts sequence coverage for multiple bams at specific loci.
#' 
#' @param bams aln.1.bam aln.2.bam ... aln.n.bam
#' @param bed <bed/gff/vcf>
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
#'   that B overlap 90 percent of A and A _also_ overlaps 90 percent of B.
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
multicov <- function(bams, bed, split = NULL, s = NULL, S = NULL, f = NULL, r = NULL, q = NULL, D = NULL, F = NULL, p = NULL)
{ 

			if (!is.character(bams) && !is.numeric(bams)) {
			bamsTable = "~/Desktop/bamsTable.txt"
			write.table(bams, bamsTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			bams=bamsTable } 
			
			if (!is.character(bed) && !is.numeric(bed)) {
			bedTable = "~/Desktop/bedTable.txt"
			write.table(bed, bedTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			bed=bedTable } 
			
		options = "" 
 
			if (!is.null(split)) {
			options = paste(options," -split")
			if(is.character(split) || is.numeric(split)) {
			options = paste(options, " ", split)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			 
			if (!is.null(S)) {
			options = paste(options," -S")
			if(is.character(S) || is.numeric(S)) {
			options = paste(options, " ", S)
			}	
			}
			 
			if (!is.null(f)) {
			options = paste(options," -f")
			if(is.character(f) || is.numeric(f)) {
			options = paste(options, " ", f)
			}	
			}
			 
			if (!is.null(r)) {
			options = paste(options," -r")
			if(is.character(r) || is.numeric(r)) {
			options = paste(options, " ", r)
			}	
			}
			 
			if (!is.null(q)) {
			options = paste(options," -q")
			if(is.character(q) || is.numeric(q)) {
			options = paste(options, " ", q)
			}	
			}
			 
			if (!is.null(D)) {
			options = paste(options," -D")
			if(is.character(D) || is.numeric(D)) {
			options = paste(options, " ", D)
			}	
			}
			 
			if (!is.null(F)) {
			options = paste(options," -F")
			if(is.character(F) || is.numeric(F)) {
			options = paste(options, " ", F)
			}	
			}
			 
			if (!is.null(p)) {
			options = paste(options," -p")
			if(is.character(p) || is.numeric(p)) {
			options = paste(options, " ", p)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools2/bin/bedtools multicov ", options, " -bams ", bams, " -bed ", bed, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("bamsTable")) { 
		file.remove (bamsTable)
		} 
 
		if(exists("bedTable")) { 
		file.remove (bedTable)
		} 
