#' Creates a batch script to create IGV images 
#' at each interval defined in a BED/GFF/VCF file.
#' 
#' @param i <bed/gff/vcf>
#' @param path The full path to which the IGV snapshots should be written.
#' (STRING) Default: ./
#' 
#' @param sess The full path to an existing IGV session file to be 
#' loaded prior to taking snapshots.
#' (STRING) Default is for no session to be loaded.
#' 
#' @param sort The type of BAM sorting you would like to apply to each image. 
#' Options: base, position, strand, quality, sample, and readGroup
#' Default is to apply no sorting at all.
#' 
#' @param clps Collapse the aligned reads prior to taking a snapshot. 
#' Default is to no collapse.
#' 
#' @param name Use the "name" field (column 4) for each image's filename. 
#' Default is to use the "chr:start-pos.ext".
#' 
#' @param slop Number of flanking base pairs on the left & right of the image.
#' - (INT) Default = 0.
#' 
#' @param img The type of image to be created. 
#' Options: png, eps, svg
#' Default is png.
#' 
igv <- function(i, path = NULL, sess = NULL, sort = NULL, clps = NULL, name = NULL, slop = NULL, img = NULL)
{ 
	options = "" 
	if (is.null(path) == FALSE) 
 	{ 
	 options = paste(options," -path", sep="")
	}
	if (is.null(sess) == FALSE) 
 	{ 
	 options = paste(options," -sess", sep="")
	}
	if (is.null(sort) == FALSE) 
 	{ 
	 options = paste(options," -sort", sep="")
	}
	if (is.null(clps) == FALSE) 
 	{ 
	 options = paste(options," -clps", sep="")
	}
	if (is.null(name) == FALSE) 
 	{ 
	 options = paste(options," -name", sep="")
	}
	if (is.null(slop) == FALSE) 
 	{ 
	 options = paste(options," -slop", sep="")
	}
	if (is.null(img) == FALSE) 
 	{ 
	 options = paste(options," -img", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools igv ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 