#' Annotates the depth & breadth of coverage of features from mult. files
#' on the intervals in -i.
#' 
#' @param i <bed/gff/vcf>
#' @param files FILE1 FILE2..FILEn
#' @param names A list of names (one / file) to describe each file in -i.
#' These names will be printed as a header line.
#' 
#' @param counts Report the count of features in each file that overlap -i.
#' - Default is to report the fraction of -i covered by each file.
#' 
#' @param both Report the counts followed by the % coverage.
#' - Default is to report the fraction of -i covered by each file.
#' 
#' @param s Require same strandedness.  That is, only counts overlaps
#' on the _same_ strand.
#' - By default, overlaps are counted without respect to strand.
#' 
#' @param S Require different strandedness.  That is, only count overlaps
#' on the _opposite_ strand.
#' - By default, overlaps are counted without respect to strand.
#' 
annotate <- function(i, files, names = NULL, counts = NULL, both = NULL, s = NULL, S = NULL)
{ 
	options = "" 
	if (is.null(names) == FALSE) 
 	{ 
	 options = paste(options," -names", sep="")
	}
	if (is.null(counts) == FALSE) 
 	{ 
	 options = paste(options," -counts", sep="")
	}
	if (is.null(both) == FALSE) 
 	{ 
	 options = paste(options," -both", sep="")
	}
	if (is.null(s) == FALSE) 
 	{ 
	 options = paste(options," -s", sep="")
	}
	if (is.null(S) == FALSE) 
 	{ 
	 options = paste(options," -S", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools annotate ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 