#' Examines a "window" around each feature in A and
#' reports all features in B that overlap the window. For each
#' overlap the entire entry in A and B are reported.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param c For each entry in A, report the number of overlaps with B.
#' - Reports 0 for A entries that have no overlap with B.
#' - Overlaps restricted by -w, -l, and -r.
#' 
#' @param Sm Only report hits in B that overlap A on the _opposite_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param sm Only report hits in B that overlap A on the _same_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
#' @param sw Define -l and -r based on strand.  For example if used, -l 500
#' for a negative-stranded feature will add 500 bp downstream.
#' - Default = disabled.
#' 
#' @param l Base pairs added upstream (left of) of each entry
#' in A when searching for overlaps in B.
#' - Allows one to define assymterical "windows".
#' - Default is 1000 bp.
#' - (INTEGER)
#' 
#' @param bed When using BAM input (-abam), write output as BED. The default
#' is to write output in BAM when using -abam.
#' 
#' @param abam The A input file is in BAM format.  Output will be BAM as well. Replaces -a.
#' 
#' @param header Print the header from the A file prior to results.
#' 
#' @param r Base pairs added downstream (right of) of each entry
#' in A when searching for overlaps in B.
#' - Allows one to define assymterical "windows".
#' - Default is 1000 bp.
#' - (INTEGER)
#' 
#' @param u Write the original A entry _once_ if _any_ overlaps found in B.
#' - In other words, just report the fact >=1 hit was found.
#' 
#' @param w Base pairs added upstream and downstream of each entry
#' in A when searching for overlaps in B.
#' - Creates symterical "windows" around A.
#' - Default is 1000 bp.
#' - (INTEGER)
#' 
#' @param v Only report those entries in A that have _no overlaps_ with B.
#' - Similar to "grep -v."
#' 
window <- function(a, b, c = NULL, Sm = NULL, sm = NULL, ubam = NULL, sw = NULL, l = NULL, bed = NULL, abam = NULL, header = NULL, r = NULL, u = NULL, w = NULL, v = NULL)
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
 
			if (!is.null(c)) {
			options = paste(options," -c")
			if(is.character(c) || is.numeric(c)) {
			options = paste(options, " ", c)
			}	
			}
			 
			if (!is.null(Sm)) {
			options = paste(options," -Sm")
			if(is.character(Sm) || is.numeric(Sm)) {
			options = paste(options, " ", Sm)
			}	
			}
			 
			if (!is.null(sm)) {
			options = paste(options," -sm")
			if(is.character(sm) || is.numeric(sm)) {
			options = paste(options, " ", sm)
			}	
			}
			 
			if (!is.null(ubam)) {
			options = paste(options," -ubam")
			if(is.character(ubam) || is.numeric(ubam)) {
			options = paste(options, " ", ubam)
			}	
			}
			 
			if (!is.null(sw)) {
			options = paste(options," -sw")
			if(is.character(sw) || is.numeric(sw)) {
			options = paste(options, " ", sw)
			}	
			}
			 
			if (!is.null(l)) {
			options = paste(options," -l")
			if(is.character(l) || is.numeric(l)) {
			options = paste(options, " ", l)
			}	
			}
			 
			if (!is.null(bed)) {
			options = paste(options," -bed")
			if(is.character(bed) || is.numeric(bed)) {
			options = paste(options, " ", bed)
			}	
			}
			 
			if (!is.null(abam)) {
			options = paste(options," -abam")
			if(is.character(abam) || is.numeric(abam)) {
			options = paste(options, " ", abam)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(r)) {
			options = paste(options," -r")
			if(is.character(r) || is.numeric(r)) {
			options = paste(options, " ", r)
			}	
			}
			 
			if (!is.null(u)) {
			options = paste(options," -u")
			if(is.character(u) || is.numeric(u)) {
			options = paste(options, " ", u)
			}	
			}
			 
			if (!is.null(w)) {
			options = paste(options," -w")
			if(is.character(w) || is.numeric(w)) {
			options = paste(options, " ", w)
			}	
			}
			 
			if (!is.null(v)) {
			options = paste(options," -v")
			if(is.character(v) || is.numeric(v)) {
			options = paste(options, " ", v)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste0(getOption("bedtools.path", default="."), "/bedtools window ", options, " -a ", a, " -b ", b, " > ", tempfile) 
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
