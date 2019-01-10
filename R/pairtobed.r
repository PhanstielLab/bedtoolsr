#' Report overlaps between a BEDPE file and a BED/GFF/VCF file.
#' 
#' @param a <bedpe>
#' @param b <bed/gff/vcf>
#' @param bedpe When using BAM input (-abam), write output as BEDPE. The default
#' is to write output in BAM when using -abam.
#' 
#' @param f Minimum overlap required as fraction of A (e.g. 0.05).
#' Default is 1E-9 (effectively 1bp).
#' 
#' @param ed Use BAM total edit distance (NM tag) for BEDPE score.
#' - Default for BEDPE is to use the minimum of
#'   of the two mapping qualities for the pair.
#' - When -ed is used the total edit distance
#'   from the two mates is reported as the score.
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' is to write output in BAM when using -abam.
#' 
#' @param S Require different strandedness when finding overlaps.
#' Default is to ignore stand.
#' Not applicable with -type inspan or -type outspan.
#' 
#' @param abam The A input file is in BAM format.  Output will be BAM as well. Replaces -a.
#' - Requires BAM to be grouped or sorted by query.
#' 
#' @param s Require same strandedness when finding overlaps.
#' Default is to ignore stand.
#' Not applicable with -type inspan or -type outspan.
#' 
#' @param type Approach to reporting overlaps between BEDPE and BED.
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
pairtobed <- function(a, b, bedpe = NULL, f = NULL, ed = NULL, ubam = NULL, S = NULL, abam = NULL, s = NULL, type = NULL)
{ 

			if (!is.character(a) && !is.numeric(a)) {
			aTable = "~/Desktop/aTable.txt"
			write.table(a, aTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			a=aTable } 
			
			if (!is.character(b) && !is.numeric(b)) {
			bTable = "~/Desktop/bTable.txt"
			write.table(b, bTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			b=bTable } 
			
		options = "" 
 
			if (!is.null(bedpe)) {
			options = paste(options," -bedpe")
			if(is.character(bedpe) || is.numeric(bedpe)) {
			options = paste(options, " ", bedpe)
			}	
			}
			 
			if (!is.null(f)) {
			options = paste(options," -f")
			if(is.character(f) || is.numeric(f)) {
			options = paste(options, " ", f)
			}	
			}
			 
			if (!is.null(ed)) {
			options = paste(options," -ed")
			if(is.character(ed) || is.numeric(ed)) {
			options = paste(options, " ", ed)
			}	
			}
			 
			if (!is.null(ubam)) {
			options = paste(options," -ubam")
			if(is.character(ubam) || is.numeric(ubam)) {
			options = paste(options, " ", ubam)
			}	
			}
			 
			if (!is.null(S)) {
			options = paste(options," -S")
			if(is.character(S) || is.numeric(S)) {
			options = paste(options, " ", S)
			}	
			}
			 
			if (!is.null(abam)) {
			options = paste(options," -abam")
			if(is.character(abam) || is.numeric(abam)) {
			options = paste(options, " ", abam)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			 
			if (!is.null(type)) {
			options = paste(options," -type")
			if(is.character(type) || is.numeric(type)) {
			options = paste(options, " ", type)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools pairtobed ", options, " -a ", a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("aTable")) { 
		file.remove (aTable)
		} 
 
		if(exists("bTable")) { 
		file.remove (bTable)
		} 
