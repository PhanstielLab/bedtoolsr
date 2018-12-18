#' Returns the depth and breadth of coverage of features from B
#' on the intervals in A.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param hist Report a histogram of coverage for each feature in A
#' as well as a summary histogram for _all_ features in A.
#' Output (tab delimited) after each feature in A:
#'   1) depth
#'   2) # bases at depth
#'   3) size of A
#'   4)  percent of A at depth
#' 
#' @param d Report the depth at each position in each A feature.
#' Positions reported are one based.  Each position
#' and depth follow the complete A feature.
#' 
#' @param counts Only report the count of overlaps, don't compute fraction, etc.
#' 
#' @param mean Report the mean depth of all positions in each A feature.
#' 
#' @param s Require same strandedness.  That is, only report hits in B
#' that overlap A on the _same_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param S Require different strandedness.  That is, only report hits in B
#' that overlap A on the _opposite_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param f Minimum overlap required as a fraction of A.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param F Minimum overlap required as a fraction of B.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param r Require that the fraction overlap be reciprocal for A AND B.
#' - In other words, if -f is 0.90 and -r is used, this requires
#'   that B overlap 90 percent of A and A _also_ overlaps 90 percent of B.
#' 
#' @param e Require that the minimum fraction be satisfied for A OR B.
#' - In other words, if -e is used with -f 0.90 and -F 0.10 this requires
#'   that either 90 percent of A is covered OR 10 percent of  B is covered.
#'   Without -e, both fractions would have to be satisfied.
#' 
#' @param split Treat "split" BAM or BED12 entries as distinct BED intervals.
#' 
#' @param g Provide a genome file to enforce consistent chromosome sort order
#' across input files. Only applies when used with -sorted option.
#' 
#' @param nonamecheck For sorted data, don't throw an error if the file has different naming conventions
#'  for the same chromosome. ex. "chr1" vs "chr01".
#' 
#' @param sorted Use the "chromsweep" algorithm for sorted (-k1,1 -k2,2n) input.
#' 
#' @param bed If using BAM input, write output as BED.
#' 
#' @param header Print the header from the A file prior to results.
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
coverage <- function(a, b, hist = NULL, d = NULL, counts = NULL, mean = NULL, s = NULL, S = NULL, f = NULL, F = NULL, r = NULL, e = NULL, split = NULL, g = NULL, nonamecheck = NULL, sorted = NULL, bed = NULL, header = NULL, nobuf = NULL, iobuf = NULL)
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
 
			if (!is.null(hist)) {
			options = paste(options," -hist")
			if(is.character(hist) || is.numeric(hist)) {
			options = paste(options, " ", hist)
			}	
			}
			 
			if (!is.null(d)) {
			options = paste(options," -d")
			if(is.character(d) || is.numeric(d)) {
			options = paste(options, " ", d)
			}	
			}
			 
			if (!is.null(counts)) {
			options = paste(options," -counts")
			if(is.character(counts) || is.numeric(counts)) {
			options = paste(options, " ", counts)
			}	
			}
			 
			if (!is.null(mean)) {
			options = paste(options," -mean")
			if(is.character(mean) || is.numeric(mean)) {
			options = paste(options, " ", mean)
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
			 
			if (!is.null(F)) {
			options = paste(options," -F")
			if(is.character(F) || is.numeric(F)) {
			options = paste(options, " ", F)
			}	
			}
			 
			if (!is.null(r)) {
			options = paste(options," -r")
			if(is.character(r) || is.numeric(r)) {
			options = paste(options, " ", r)
			}	
			}
			 
			if (!is.null(e)) {
			options = paste(options," -e")
			if(is.character(e) || is.numeric(e)) {
			options = paste(options, " ", e)
			}	
			}
			 
			if (!is.null(split)) {
			options = paste(options," -split")
			if(is.character(split) || is.numeric(split)) {
			options = paste(options, " ", split)
			}	
			}
			 
			if (!is.null(g)) {
			options = paste(options," -g")
			if(is.character(g) || is.numeric(g)) {
			options = paste(options, " ", g)
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
			 
			if (!is.null(bed)) {
			options = paste(options," -bed")
			if(is.character(bed) || is.numeric(bed)) {
			options = paste(options, " ", bed)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(nobuf)) {
			options = paste(options," -nobuf")
			if(is.character(nobuf) || is.numeric(nobuf)) {
			options = paste(options, " ", nobuf)
			}	
			}
			 
			if (!is.null(iobuf)) {
			options = paste(options," -iobuf")
			if(is.character(iobuf) || is.numeric(iobuf)) {
			options = paste(options, " ", iobuf)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools2/bin/bedtools coverage ", options, " -a ", a, " -b ", b, " > ", tempfile) 
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
