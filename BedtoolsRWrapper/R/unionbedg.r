#' Combines multiple BedGraph files into a single file,
#' allowing coverage comparisons between them.
#' 
#' @param i FILE1 FILE2 .. FILEn
#' Assumes that each BedGraph file is sorted by chrom/start 
#' and that the intervals in each are non
#' @param overlapping. 
#' @param header  Print a header line.
#'  (chrom/start/end + names of each file).
#' 
#' @param names  A list of names (one/file) to describe each file in -i.
#'  These names will be printed in the header line.
#' 
#' @param g  Use genome file to calculate empty regions.
#'  - STRING.
#' 
#' @param empty  Report empty regions (i.e., start/end intervals w/o
#'  values in all files).
#'  - Requires the '-g FILE' parameter.
#' 
#' @param filler TEXT Use TEXT when representing intervals having no value.
#'  - Default is '0', but you can use 'N/A' or any text.
#' 
#' @param examples Show detailed usage examples.
#' 
unionbedg <- function(i, overlapping., header = NULL, names = NULL, g = NULL, empty = NULL, filler TEXT = NULL, examples = NULL)
{ 
	options = "" 
	if (is.null(header) == FALSE) 
 	{ 
	 options = paste(options," -header", sep="")
	}
	if (is.null(names) == FALSE) 
 	{ 
	 options = paste(options," -names", sep="")
	}
	if (is.null(g) == FALSE) 
 	{ 
	 options = paste(options," -g", sep="")
	}
	if (is.null(empty) == FALSE) 
 	{ 
	 options = paste(options," -empty", sep="")
	}
	if (is.null(filler TEXT) == FALSE) 
 	{ 
	 options = paste(options," -filler TEXT", sep="")
	}
	if (is.null(examples) == FALSE) 
 	{ 
	 options = paste(options," -examples", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools unionbedg ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 