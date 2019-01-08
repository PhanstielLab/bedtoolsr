#' Report overlaps between two paired-end BED files (BEDPE).
#' 
#' @param a <BEDPE>
#' @param b <BEDPE>
#' @param slop The amount of slop (in b.p.). to be added to each footprint of A.
#' *Note*: Slop is subtracted from start1 and start2
#'  and added to end1 and end2.
#' - Default = 0.
#' 
#' @param f Minimum overlap required as fraction of A (e.g. 0.05).
#' Default is 1E-9 (effectively 1bp).
#' 
#' @param ss Add slop based to each BEDPE footprint based on strand.
#' - If strand is "+", slop is only added to the end coordinates.
#' - If strand is "-", slop is only added to the start coordinates.
#' - By default, slop is added in both directions.
#' 
#' @param is Ignore strands when searching for overlaps.
#' - By default, strands are enforced.
#' 
#' @param rdn Require the hits to have different names (i.e. avoid self-hits).
#' - By default, same names are allowed.
#' 
#' @param type Approach to reporting overlaps between A and B.
#' neither Report overlaps if neither end of A overlaps B.
#' either Report overlaps if either ends of A overlap B.
#' both Report overlaps if both ends of A overlap B.
#' notboth Report overlaps if one or neither of A's overlap B.
#' - Default = both.
#' 
pairtopair <- function(a, b, slop = NULL, f = NULL, ss = NULL, is = NULL, rdn = NULL, type = NULL)
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
 
			if (!is.null(slop)) {
			options = paste(options," -slop")
			if(is.character(slop) || is.numeric(slop)) {
			options = paste(options, " ", slop)
			}	
			}
			 
			if (!is.null(f)) {
			options = paste(options," -f")
			if(is.character(f) || is.numeric(f)) {
			options = paste(options, " ", f)
			}	
			}
			 
			if (!is.null(ss)) {
			options = paste(options," -ss")
			if(is.character(ss) || is.numeric(ss)) {
			options = paste(options, " ", ss)
			}	
			}
			 
			if (!is.null(is)) {
			options = paste(options," -is")
			if(is.character(is) || is.numeric(is)) {
			options = paste(options, " ", is)
			}	
			}
			 
			if (!is.null(rdn)) {
			options = paste(options," -rdn")
			if(is.character(rdn) || is.numeric(rdn)) {
			options = paste(options, " ", rdn)
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
	cmd = paste0(getOption("bedtools.path", default="."), "/bedtools pairtopair ", options, " -a ", a, " -b ", b, " > ", tempfile) 
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
