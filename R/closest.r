#' For each feature in A, finds the closest 
#' feature (upstream or downstream) in B.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param mdb How multiple databases are resolved.
#' - "each"    Report closest records for each database (default).
#' - "all"  Report closest records among all databases.
#' 
#' @param iu Ignore features in B that are upstream of features in A.
#' This option requires -D and follows its orientation
#' rules for determining what is "upstream".
#' 
#' @param header Print the header from the A file prior to results.
#' 
#' @param names When using multiple databases, provide an alias for each that
#' will appear instead of a fileId when also printing the DB record.
#' 
#' @param io Ignore features in B that overlap A.  That is, we want close,
#' yet not touching features only.
#' 
#' @param nonamecheck For sorted data, don't throw an error if the file has different naming conventions
#'  for the same chromosome. ex. "chr1" vs "chr01".
#' 
#' @param id Ignore features in B that are downstream of features in A.
#' This option requires -D and follows its orientation
#' rules for determining what is "downstream".
#' 
#' @param D Like -d, report the closest feature in B, and its distance to A
#' as an extra column. Unlike -d, use negative distances to report
#' upstream features.
#' The options for defining which orientation is "upstream" are:
#' - "ref"   Report distance with respect to the reference genome. 
#'             B features with a lower (start, stop) are upstream
#' - "a"     Report distance with respect to A.
#'             When A is on the - strand, "upstream" means B has a
#'             higher (start,stop).
#' - "b"     Report distance with respect to B.
#'             When B is on the - strand, "upstream" means A has a
#'             higher (start,stop).
#' 
#' @param split Treat "split" BAM or BED12 entries as distinct BED intervals.
#' 
#' @param fu Choose first from features in B that are upstream of features in A.
#' This option requires -D and follows its orientation
#' rules for determining what is "upstream".
#' 
#' @param F Minimum overlap required as a fraction of B.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param N Require that the query and the closest hit have different names.
#' For BED, the 4th column is compared.
#' 
#' @param S Require different strandedness.  That is, only report hits in B
#' that overlap A on the _opposite_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param fd Choose first from features in B that are downstream of features in A.
#' This option requires -D and follows its orientation
#' rules for determining what is "downstream".
#' 
#' @param filenames When using multiple databases, show each complete filename
#'  instead of a fileId when also printing the DB record.
#' 
#' @param e Require that the minimum fraction be satisfied for A OR B.
#' - In other words, if -e is used with -f 0.90 and -F 0.10 this requires
#'   that either 90 percent of A is covered OR 10 percent of  B is covered.
#'   Without -e, both fractions would have to be satisfied.
#' 
#' @param d In addition to the closest feature in B, 
#' report its distance to A as an extra column.
#' - The reported distance for overlapping features will be 0.
#' 
#' @param g Provide a genome file to enforce consistent chromosome sort order
#' across input files. Only applies when used with -sorted option.
#' 
#' @param f Minimum overlap required as a fraction of A.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param k Report the k closest hits. Default is 1. If tieMode = "all", 
#' - all ties will still be reported.
#' 
#' @param sortout When using multiple databases, sort the output DB hits
#'  for each record.
#' 
#' @param bed If using BAM input, write output as BED.
#' 
#' @param s Require same strandedness.  That is, only report hits in B
#' that overlap A on the _same_ strand.
#' - By default, overlaps are reported without respect to strand.
#' 
#' @param r Require that the fraction overlap be reciprocal for A AND B.
#' - In other words, if -f is 0.90 and -r is used, this requires
#'   that B overlap 90 percent of A and A _also_ overlaps 90 percent of B.
#' 
#' @param t How ties for closest feature are handled.  This occurs when two
#' features in B have exactly the same "closeness" with A.
#' By default, all such features in B are reported.
#' Here are all the options:
#' - "all"    Report all ties (default).
#' - "first"  Report the first tie that occurred in the B file.
#' - "last"   Report the last tie that occurred in the B file.
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
closest <- function(a, b, mdb = NULL, iu = NULL, header = NULL, names = NULL, io = NULL, nonamecheck = NULL, id = NULL, D = NULL, split = NULL, fu = NULL, F = NULL, N = NULL, S = NULL, fd = NULL, filenames = NULL, e = NULL, d = NULL, g = NULL, f = NULL, k = NULL, sortout = NULL, bed = NULL, s = NULL, r = NULL, t = NULL, iobuf = NULL, nobuf = NULL)
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
 
			if (!is.null(mdb)) {
			options = paste(options," -mdb")
			if(is.character(mdb) || is.numeric(mdb)) {
			options = paste(options, " ", mdb)
			}	
			}
			 
			if (!is.null(iu)) {
			options = paste(options," -iu")
			if(is.character(iu) || is.numeric(iu)) {
			options = paste(options, " ", iu)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(names)) {
			options = paste(options," -names")
			if(is.character(names) || is.numeric(names)) {
			options = paste(options, " ", names)
			}	
			}
			 
			if (!is.null(io)) {
			options = paste(options," -io")
			if(is.character(io) || is.numeric(io)) {
			options = paste(options, " ", io)
			}	
			}
			 
			if (!is.null(nonamecheck)) {
			options = paste(options," -nonamecheck")
			if(is.character(nonamecheck) || is.numeric(nonamecheck)) {
			options = paste(options, " ", nonamecheck)
			}	
			}
			 
			if (!is.null(id)) {
			options = paste(options," -id")
			if(is.character(id) || is.numeric(id)) {
			options = paste(options, " ", id)
			}	
			}
			 
			if (!is.null(D)) {
			options = paste(options," -D")
			if(is.character(D) || is.numeric(D)) {
			options = paste(options, " ", D)
			}	
			}
			 
			if (!is.null(split)) {
			options = paste(options," -split")
			if(is.character(split) || is.numeric(split)) {
			options = paste(options, " ", split)
			}	
			}
			 
			if (!is.null(fu)) {
			options = paste(options," -fu")
			if(is.character(fu) || is.numeric(fu)) {
			options = paste(options, " ", fu)
			}	
			}
			 
			if (!is.null(F)) {
			options = paste(options," -F")
			if(is.character(F) || is.numeric(F)) {
			options = paste(options, " ", F)
			}	
			}
			 
			if (!is.null(N)) {
			options = paste(options," -N")
			if(is.character(N) || is.numeric(N)) {
			options = paste(options, " ", N)
			}	
			}
			 
			if (!is.null(S)) {
			options = paste(options," -S")
			if(is.character(S) || is.numeric(S)) {
			options = paste(options, " ", S)
			}	
			}
			 
			if (!is.null(fd)) {
			options = paste(options," -fd")
			if(is.character(fd) || is.numeric(fd)) {
			options = paste(options, " ", fd)
			}	
			}
			 
			if (!is.null(filenames)) {
			options = paste(options," -filenames")
			if(is.character(filenames) || is.numeric(filenames)) {
			options = paste(options, " ", filenames)
			}	
			}
			 
			if (!is.null(e)) {
			options = paste(options," -e")
			if(is.character(e) || is.numeric(e)) {
			options = paste(options, " ", e)
			}	
			}
			 
			if (!is.null(d)) {
			options = paste(options," -d")
			if(is.character(d) || is.numeric(d)) {
			options = paste(options, " ", d)
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
			 
			if (!is.null(k)) {
			options = paste(options," -k")
			if(is.character(k) || is.numeric(k)) {
			options = paste(options, " ", k)
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
			 
			if (!is.null(t)) {
			options = paste(options," -t")
			if(is.character(t) || is.numeric(t)) {
			options = paste(options, " ", t)
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
	cmd = paste0(getOption("bedtools.path", default="."), "/bedtools closest ", options, " -a ", a, " -b ", b, " > ", tempfile) 
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
