#' Annotates the depth & breadth of coverage of features from mult. files
#' on the intervals in -i.
#' 
#' @param i <bed/gff/vcf>
#' @param files FILE1 FILE2..FILEn
#' @param S Require different strandedness.  That is, only count overlaps
#' on the _opposite_ strand.
#' - By default, overlaps are counted without respect to strand.
#' 
#' @param both Report the counts followed by the  percent coverage.
#' - Default is to report the fraction of -i covered by each file.
#' 
#' @param counts Report the count of features in each file that overlap -i.
#' - Default is to report the fraction of -i covered by each file.
#' 
#' @param s Require same strandedness.  That is, only counts overlaps
#' on the _same_ strand.
#' - By default, overlaps are counted without respect to strand.
#' 
#' @param names A list of names (one / file) to describe each file in -i.
#' These names will be printed as a header line.
#' 
annotate <- function(i, files, S = NULL, both = NULL, counts = NULL, s = NULL, names = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
			if (!is.character(files) && !is.numeric(files)) {
			filesTable = "~/Desktop/filesTable.txt"
			write.table(files, filesTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			files=filesTable } 
			
		options = "" 
 
			if (!is.null(S)) {
			options = paste(options," -S")
			if(is.character(S) || is.numeric(S)) {
			options = paste(options, " ", S)
			}	
			}
			 
			if (!is.null(both)) {
			options = paste(options," -both")
			if(is.character(both) || is.numeric(both)) {
			options = paste(options, " ", both)
			}	
			}
			 
			if (!is.null(counts)) {
			options = paste(options," -counts")
			if(is.character(counts) || is.numeric(counts)) {
			options = paste(options, " ", counts)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			 
			if (!is.null(names)) {
			options = paste(options," -names")
			if(is.character(names) || is.numeric(names)) {
			options = paste(options, " ", names)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste0(getOption("bedtools.path", default="."), "/bedtools annotate ", options, " -i ", i, " -files ", files, " > ", tempfile) 
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
