#' Sorts a feature file in various and useful ways.
#' 
#' @param i <bed/gff/vcf>
#' @param sizeA   Sort by feature size in ascending order.
#' 
#' @param sizeD   Sort by feature size in descending order.
#' 
#' @param chrThenSizeA  Sort by chrom (asc), then feature size (asc).
#' 
#' @param chrThenSizeD  Sort by chrom (asc), then feature size (desc).
#' 
#' @param chrThenScoreA  Sort by chrom (asc), then score (asc).
#' 
#' @param chrThenScoreD  Sort by chrom (asc), then score (desc).
#' 
#' @param g (names.txt) Sort according to the chromosomes declared in "genome.txt"
#' 
#' @param faidx (names.txt) Sort according to the chromosomes declared in "names.txt"
#' 
#' @param header Print the header from the A file prior to results.
#' 
sort <- function(i, sizeA = NULL, sizeD = NULL, chrThenSizeA = NULL, chrThenSizeD = NULL, chrThenScoreA = NULL, chrThenScoreD = NULL, g (names.txt) = NULL, faidx (names.txt) = NULL, header = NULL)
{ 
	options = "" 
	if (is.null(sizeA) == FALSE) 
 	{ 
	 options = paste(options," -sizeA", sep="")
	}
	if (is.null(sizeD) == FALSE) 
 	{ 
	 options = paste(options," -sizeD", sep="")
	}
	if (is.null(chrThenSizeA) == FALSE) 
 	{ 
	 options = paste(options," -chrThenSizeA", sep="")
	}
	if (is.null(chrThenSizeD) == FALSE) 
 	{ 
	 options = paste(options," -chrThenSizeD", sep="")
	}
	if (is.null(chrThenScoreA) == FALSE) 
 	{ 
	 options = paste(options," -chrThenScoreA", sep="")
	}
	if (is.null(chrThenScoreD) == FALSE) 
 	{ 
	 options = paste(options," -chrThenScoreD", sep="")
	}
	if (is.null(g (names.txt)) == FALSE) 
 	{ 
	 options = paste(options," -g (names.txt)", sep="")
	}
	if (is.null(faidx (names.txt)) == FALSE) 
 	{ 
	 options = paste(options," -faidx (names.txt)", sep="")
	}
	if (is.null(header) == FALSE) 
 	{ 
	 options = paste(options," -header", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools sort ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 