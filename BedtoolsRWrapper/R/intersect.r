#' Report overlaps between two feature files.
#' 
#' @param a <bed/gff/vcf/bam>
#' @param b <bed/gff/vcf/bam>
#' @param wa Write the original entry in A for each overlap.
#' 
#' @param wb Write the original entry in B for each overlap.
#' - Useful for knowing _what_ A overlaps. Restricted by -f and -r.
#' 
#' @param loj Perform a "left outer join". That is, for each feature in A
#' report each overlap with B.  If no overlaps are found, 
#' report a NULL feature for B.
#' 
#' @param wo Write the original A and B entries plus the number of base
#' pairs of overlap between the two features.
#' - Overlaps restricted by -f and -r.
#'   Only A features with overlap are reported.
#' 
#' @param wao Write the original A and B entries plus the number of base
#' pairs of overlap between the two features.
#' - Overlapping features restricted by -f and -r.
#'   However, A features w/o overlap are also reported
#'   with a NULL B feature and overlap = 0.
#' 
#' @param u Write the original A entry _once_ if _any_ overlaps found in B.
#' - In other words, just report the fact >=1 hit was found.
#' - Overlaps restricted by -f and -r.
#' 
#' @param c For each entry in A, report the number of overlaps with B.
#' - Reports 0 for A entries that have no overlap with B.
#' - Overlaps restricted by -f and -r.
#' 
#' @param v Only report those entries in A that have _no overlaps_ with B.
#' - Similar to "grep -v" (an homage).
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
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
#' @param names When using multiple databases, provide an alias for each that
#' will appear instead of a fileId when also printing the DB record.
#' 
#' @param filenames When using multiple databases, show each complete filename
#'  instead of a fileId when also printing the DB record.
#' 
#' @param sortout When using multiple databases, sort the output DB hits
#'  for each record.
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
intersect <- function(a, b, wa = NULL, wb = NULL, loj = NULL, wo = NULL, wao = NULL, u = NULL, c = NULL, v = NULL, ubam = NULL, s = NULL, S = NULL, f = NULL, F = NULL, r = NULL, e = NULL, split = NULL, g = NULL, nonamecheck = NULL, sorted = NULL, names = NULL, filenames = NULL, sortout = NULL, bed = NULL, header = NULL, nobuf = NULL, iobuf = NULL)
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
 
			if (!is.null(wa)) {
			options = paste(options," -wa")
			if(is.character(wa) || is.numeric(wa)) {
			options = paste(options, " ", wa)
			}	
			}
			 
			if (!is.null(wb)) {
			options = paste(options," -wb")
			if(is.character(wb) || is.numeric(wb)) {
			options = paste(options, " ", wb)
			}	
			}
			 
			if (!is.null(loj)) {
			options = paste(options," -loj")
			if(is.character(loj) || is.numeric(loj)) {
			options = paste(options, " ", loj)
			}	
			}
			 
			if (!is.null(wo)) {
			options = paste(options," -wo")
			if(is.character(wo) || is.numeric(wo)) {
			options = paste(options, " ", wo)
			}	
			}
			 
			if (!is.null(wao)) {
			options = paste(options," -wao")
			if(is.character(wao) || is.numeric(wao)) {
			options = paste(options, " ", wao)
			}	
			}
			 
			if (!is.null(u)) {
			options = paste(options," -u")
			if(is.character(u) || is.numeric(u)) {
			options = paste(options, " ", u)
			}	
			}
			 
			if (!is.null(c)) {
			options = paste(options," -c")
			if(is.character(c) || is.numeric(c)) {
			options = paste(options, " ", c)
			}	
			}
			 
			if (!is.null(v)) {
			options = paste(options," -v")
			if(is.character(v) || is.numeric(v)) {
			options = paste(options, " ", v)
			}	
			}
			 
			if (!is.null(ubam)) {
			options = paste(options," -ubam")
			if(is.character(ubam) || is.numeric(ubam)) {
			options = paste(options, " ", ubam)
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
			 
			if (!is.null(names)) {
			options = paste(options," -names")
			if(is.character(names) || is.numeric(names)) {
			options = paste(options, " ", names)
			}	
			}
			 
			if (!is.null(filenames)) {
			options = paste(options," -filenames")
			if(is.character(filenames) || is.numeric(filenames)) {
			options = paste(options, " ", filenames)
			}	
			}
			 
			if (!is.null(sortout)) {
			options = paste(options," -sortout")
			if(is.character(sortout) || is.numeric(sortout)) {
			options = paste(options, " ", sortout)
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
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools2/bin/bedtools intersect ", options, " -a ", a, " -b ", b, " > ", tempfile) 
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
