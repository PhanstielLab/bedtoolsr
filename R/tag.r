#' Annotates a BAM file based on overlaps with multiple BED/GFF/VCF files
#' on the intervals in -i.
#' 
#' @param i <BAM>
#' @param files FILE1 .. FILEn
#' @param labels LAB1 .. LABn
#' @param f Minimum overlap required as a fraction of the alignment.
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param S Require overlaps on the opposite strand.  That is, only tag alignments that have the opposite
#' strand as a feature in the annotation file(s).
#' 
#' @param intervals Use the full interval (including name, score, and strand) to populate tags.
#'  Requires the -labels option to identify from which file the interval came.
#' 
#' @param s Require overlaps on the same strand.  That is, only tag alignments that have the same
#' strand as a feature in the annotation file(s).
#' 
#' @param tag Dictate what the tag should be. Default is YB.
#' - STRING (two characters, e.g., YK)
#' 
#' @param names Use the name field from the annotation files to populate tags.
#' By default, the -labels values are used.
#' 
#' @param scores Use the score field from the annotation files to populate tags.
#' By default, the -labels values are used.
#' 
tag <- function(i, files, labels, f = NULL, S = NULL, intervals = NULL, s = NULL, tag = NULL, names = NULL, scores = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
			if (!is.character(files) && !is.numeric(files)) {
			filesTable = "~/Desktop/filesTable.txt"
			write.table(files, filesTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			files=filesTable } 
			
			if (!is.character(labels) && !is.numeric(labels)) {
			labelsTable = "~/Desktop/labelsTable.txt"
			write.table(labels, labelsTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			labels=labelsTable } 
			
		options = "" 
 
			if (!is.null(f)) {
			options = paste(options," -f")
			if(is.character(f) || is.numeric(f)) {
			options = paste(options, " ", f)
			}	
			}
			 
			if (!is.null(S)) {
			options = paste(options," -S")
			if(is.character(S) || is.numeric(S)) {
			options = paste(options, " ", S)
			}	
			}
			 
			if (!is.null(intervals)) {
			options = paste(options," -intervals")
			if(is.character(intervals) || is.numeric(intervals)) {
			options = paste(options, " ", intervals)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			 
			if (!is.null(tag)) {
			options = paste(options," -tag")
			if(is.character(tag) || is.numeric(tag)) {
			options = paste(options, " ", tag)
			}	
			}
			 
			if (!is.null(names)) {
			options = paste(options," -names")
			if(is.character(names) || is.numeric(names)) {
			options = paste(options, " ", names)
			}	
			}
			 
			if (!is.null(scores)) {
			options = paste(options," -scores")
			if(is.character(scores) || is.numeric(scores)) {
			options = paste(options, " ", scores)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste0(getOption("bedtools.path", default="."), "/bedtools tag ", options, " -i ", i, " -files ", files, " -labels ", labels, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("iTable")) { 
		file.remove (iTable)
		} 
 
		if(exists("filesTable")) { 
		file.remove (filesTable)
		} 
 
		if(exists("labelsTable")) { 
		file.remove (labelsTable)
		} 
