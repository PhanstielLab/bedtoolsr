#' Removes the portion(s) of an interval that is overlapped
#' by another feature(s).
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param A Remove entire feature if any overlap.  That is, by default,
#' only subtract the portion of A that overlaps B. Here, if
#' any overlap is found (or -f amount), the entire feature is removed.
#' 
#' @param e Require that the minimum fraction be satisfied for A OR B.
#' - In other words, if -e is used with -f 0.90 and -F 0.10 this requires
#'   that either 90 percent of A is covered OR 10 percent of  B is covered.
#'   Without -e, both fractions would have to be satisfied.
#' 
#' @param wb Write the original entry in B for each overlap.
#' - Useful for knowing _what_ A overlaps. Restricted by -f and -r.
#' 
#' @param g Provide a genome file to enforce consistent chromosome sort order
#' across input files. Only applies when used with -sorted option.
#' 
#' @param f Minimum overlap required as a fraction of A.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param wo Write the original A and B entries plus the number of base
#' pairs of overlap between the two features.
#' - Overlaps restricted by -f and -r.
#'   Only A features with overlap are reported.
#' 
#' @param F Minimum overlap required as a fraction of B.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param S Require different strandedness.  That is, only report hits in B
#' that overlap A on the _opposite_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param bed If using BAM input, write output as BED.
#' 
#' @param N Same as -A except when used with -f, the amount is the sum
#' of all features (not any single feature).
#' 
#' @param header Print the header from the A file prior to results.
#' 
#' @param s Require same strandedness.  That is, only report hits in B
#' that overlap A on the _same_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param r Require that the fraction overlap be reciprocal for A AND B.
#' - In other words, if -f is 0.90 and -r is used, this requires
#'   that B overlap 90 percent of A and A _also_ overlaps 90 percent of B.
#' 
#' @param split Treat "split" BAM or BED12 entries as distinct BED intervals.
#' 
#' @param nonamecheck For sorted data, don't throw an error if the file has different naming conventions
#'  for the same chromosome. ex. "chr1" vs "chr01".
#' 
#' @param sorted Use the "chromsweep" algorithm for sorted (-k1,1 -k2,2n) input.
#' 
#' @param iobuf Specify amount of memory to use for input buffer.
#' Takes an integer argument. Optional suffixes K/M/G supported.
#' Note: currently has no effect with compressed files.
#' 
#' @param nobuf Disable buffered output. Using this option will cause each line
#' of output to be printed as it is generated, rather than saved
#' in a buffer. This will make printing large output files 
#' noticeably slower, but can be useful in conjunction with
#' other software tools and scripts that need to process one
#' line of bedtools output at a time.
#' 
subtract <- function(a, b, A = NULL, e = NULL, wb = NULL, g = NULL, f = NULL, wo = NULL, F = NULL, S = NULL, bed = NULL, N = NULL, header = NULL, s = NULL, r = NULL, split = NULL, nonamecheck = NULL, sorted = NULL, iobuf = NULL, nobuf = NULL)
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
 
			if (!is.null(A)) {
			options = paste(options," -A")
			if(is.character(A) || is.numeric(A)) {
			options = paste(options, " ", A)
			}	
			}
			 
			if (!is.null(e)) {
			options = paste(options," -e")
			if(is.character(e) || is.numeric(e)) {
			options = paste(options, " ", e)
			}	
			}
			 
			if (!is.null(wb)) {
			options = paste(options," -wb")
			if(is.character(wb) || is.numeric(wb)) {
			options = paste(options, " ", wb)
			}	
			}
			 
			if (!is.null(g)) {
			options = paste(options," -g")
			if(is.character(g) || is.numeric(g)) {
			options = paste(options, " ", g)
			}	
			}
			 
			if (!is.null(f)) {
			options = paste(options," -f")
			if(is.character(f) || is.numeric(f)) {
			options = paste(options, " ", f)
			}	
			}
			 
			if (!is.null(wo)) {
			options = paste(options," -wo")
			if(is.character(wo) || is.numeric(wo)) {
			options = paste(options, " ", wo)
			}	
			}
			 
			if (!is.null(F)) {
			options = paste(options," -F")
			if(is.character(F) || is.numeric(F)) {
			options = paste(options, " ", F)
			}	
			}
			 
			if (!is.null(S)) {
			options = paste(options," -S")
			if(is.character(S) || is.numeric(S)) {
			options = paste(options, " ", S)
			}	
			}
			 
			if (!is.null(bed)) {
			options = paste(options," -bed")
			if(is.character(bed) || is.numeric(bed)) {
			options = paste(options, " ", bed)
			}	
			}
			 
			if (!is.null(N)) {
			options = paste(options," -N")
			if(is.character(N) || is.numeric(N)) {
			options = paste(options, " ", N)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			 
			if (!is.null(r)) {
			options = paste(options," -r")
			if(is.character(r) || is.numeric(r)) {
			options = paste(options, " ", r)
			}	
			}
			 
			if (!is.null(split)) {
			options = paste(options," -split")
			if(is.character(split) || is.numeric(split)) {
			options = paste(options, " ", split)
			}	
			}
			 
			if (!is.null(nonamecheck)) {
			options = paste(options," -nonamecheck")
			if(is.character(nonamecheck) || is.numeric(nonamecheck)) {
			options = paste(options, " ", nonamecheck)
			}	
			}
			 
			if (!is.null(sorted)) {
			options = paste(options," -sorted")
			if(is.character(sorted) || is.numeric(sorted)) {
			options = paste(options, " ", sorted)
			}	
			}
			 
			if (!is.null(iobuf)) {
			options = paste(options," -iobuf")
			if(is.character(iobuf) || is.numeric(iobuf)) {
			options = paste(options, " ", iobuf)
			}	
			}
			 
			if (!is.null(nobuf)) {
			options = paste(options," -nobuf")
			if(is.character(nobuf) || is.numeric(nobuf)) {
			options = paste(options, " ", nobuf)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste(getOption("bedtools.path"), " bedtools subtract ", options, " -a ", a, " -b ", b, " > ", tempfile) 
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
