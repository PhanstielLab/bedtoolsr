#' Report overlaps between a BEDPE file and a BED/GFF/VCF file.
#' 
#' @param a <bedpe>
#' @param b <bed/gff/vcf>
#' @param abam The A input file is in BAM format.  Output will be BAM as well. Replaces -a.
#' - Requires BAM to be grouped or sorted by query.
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' is to write output in BAM when using -abam.
#' 
#' @param bedpe When using BAM input (-abam), write output as BEDPE. The default
#' is to write output in BAM when using -abam.
#' 
#' @param ed Use BAM total edit distance (NM tag) for BEDPE score.
#' - Default for BEDPE is to use the minimum of
#'   of the two mapping qualities for the pair.
#' - When -ed is used the total edit distance
#'   from the two mates is reported as the score.
#' 
#' @param f Minimum overlap required as fraction of A (e.g. 0.05).
#' Default is 1E-9 (effectively 1bp).
#' 
#' @param s Require same strandedness when finding overlaps.
#' Default is to ignore stand.
#' Not applicable with -type inspan or -type outspan.
#' 
#' @param S Require different strandedness when finding overlaps.
#' Default is to ignore stand.
#' Not applicable with -type inspan or -type outspan.
#' 
#' @param type  Approach to reporting overlaps between BEDPE and BED.
#' either Report overlaps if either end of A overlaps B.
#'  - Default.
#' neither Report A if neither end of A overlaps B.
#' both Report overlaps if both ends of A overlap  B.
#' xor Report overlaps if one and only one end of A overlaps B.
#' notboth Report overlaps if neither end or one and only one 
#'  end of A overlap B.  That is, xor + neither.
#' ispan Report overlaps between [end1, start2] of A and B.
#'  - Note: If chrom1 <> chrom2, entry is ignored.
#' ospan Report overlaps between [start1, end2] of A and B.
#'  - Note: If chrom1 <> chrom2, entry is ignored.
#' notispan Report A if ispan of A doesn't overlap B.
#'   - Note: If chrom1 <> chrom2, entry is ignored.
#' notospan Report A if ospan of A doesn't overlap B.
#'   - Note: If chrom1 <> chrom2, entry is ignored.
#' 
pairtobed <- function(a, b, abam = NULL, ubam = NULL, bedpe = NULL, ed = NULL, f = NULL, s = NULL, S = NULL, type  = NULL)
{ 
	options = "" 
	if (is.null(abam) == FALSE) 
 	{ 
	 options = paste(options," -abam", sep="")
	}
	if (is.null(ubam) == FALSE) 
 	{ 
	 options = paste(options," -ubam", sep="")
	}
	if (is.null(bedpe) == FALSE) 
 	{ 
	 options = paste(options," -bedpe", sep="")
	}
	if (is.null(ed) == FALSE) 
 	{ 
	 options = paste(options," -ed", sep="")
	}
	if (is.null(f) == FALSE) 
 	{ 
	 options = paste(options," -f", sep="")
	}
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
	}
	if (is.null(S) == FALSE) 
 	{ 
	 options = paste(options," -S", sep="")
	}
	if (is.null(type ) == FALSE) 
 	{ 
	 options = paste(options," -type ", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools pairtobed ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 