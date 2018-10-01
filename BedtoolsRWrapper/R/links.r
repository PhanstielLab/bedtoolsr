#' Creates HTML links to an UCSC Genome Browser from a feature file.
#' 
#' @param i <bed/gff/vcf> > out.html
#' @param base The browser basename.  Default: http://genome.ucsc.edu 
#' 
#' @param org The organism. Default: human
#' 
#' @param db The build.  Default: hg18
#' 
links <- function(i, base = NULL, org = NULL, db = NULL)
{ 
	options = "" 
	if (is.null(base) == FALSE) 
 	{ 
	 options = paste(options," -base", sep="")
	}
	if (is.null(org) == FALSE) 
 	{ 
	 options = paste(options," -org", sep="")
	}
	if (is.null(db) == FALSE) 
 	{ 
	 options = paste(options," -db", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools links ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 