#' Randomly permute the locations of a feature file among a genome.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param excl A BED/GFF/VCF file of coordinates in which features in -i
#' should not be placed (e.g. gaps.bed).
#' 
#' @param incl Instead of randomly placing features in a genome, the -incl
#' options defines a BED/GFF/VCF file of coordinates in which 
#' features in -i should be randomly placed (e.g. genes.bed). 
#' Larger -incl intervals will contain more shuffled regions. 
#' This method DISABLES -chromFirst. 
#' 
#' @param chrom Keep features in -i on the same chromosome.
#' - By default, the chrom and position are randomly chosen.
#' - NOTE: Forces use of -chromFirst (see below).
#' 
#' @param seed Supply an integer seed for the shuffling.
#' - By default, the seed is chosen automatically.
#' - (INTEGER)
#' 
#' @param f Maximum overlap (as a fraction of the -i feature) with an -excl
#' feature that is tolerated before searching for a new, 
#' randomized locus. For example, -f 0.10 allows up to 10%
#' of a randomized feature to overlap with a given feature
#' in the -excl file. **Cannot be used with -incl file.**
#' - Default is 1E-9 (i.e., 1bp).
#' - FLOAT (e.g. 0.50)
#' 
#' @param chromFirst 
#' Instead of choosing a position randomly among the entire
#' genome (the default), first choose a chrom randomly, and then
#' choose a random start coordinate on that chrom.  This leads
#' to features being ~uniformly distributed among the chroms,
#' as opposed to features being distribute as a function of chrom size.
#' 
#' @param bedpe Indicate that the A file is in BEDPE format.
#' 
#' @param maxTries 
#' Max. number of attempts to find a home for a shuffled interval
#' in the presence of -incl or -excl.
#' Default = 1000.
#' 
#' @param noOverlapping 
#' Don't allow shuffled intervals to overlap.
#' 
#' @param allowBeyondChromEnd 
#' Allow shuffled intervals to be relocated to a position
#' in which the entire original interval cannot fit w/o exceeding
#' the end of the chromosome.  In this case, the end coordinate of the
#' shuffled interval will be set to the chromosome's length.
#' By default, an interval's original length must be fully-contained
#' within the chromosome.
#' 
shuffle <- function(i, g, excl = NULL, incl = NULL, chrom = NULL, seed = NULL, f = NULL, chromFirst = NULL, bedpe = NULL, maxTries = NULL, noOverlapping = NULL, allowBeyondChromEnd = NULL)
{ 
	options = "" 
	if (is.null(excl) == FALSE) 
 	{ 
	 options = paste(options," -excl", sep="")
	}
	if (is.null(incl) == FALSE) 
 	{ 
	 options = paste(options," -incl", sep="")
	}
	if (is.null(chrom) == FALSE) 
 	{ 
	 options = paste(options," -chrom", sep="")
	}
	if (is.null(seed) == FALSE) 
 	{ 
	 options = paste(options," -seed", sep="")
	}
	if (is.null(f) == FALSE) 
 	{ 
	 options = paste(options," -f", sep="")
	}
	if (is.null(chromFirst) == FALSE) 
 	{ 
	 options = paste(options," -chromFirst", sep="")
	}
	if (is.null(bedpe) == FALSE) 
 	{ 
	 options = paste(options," -bedpe", sep="")
	}
	if (is.null(maxTries) == FALSE) 
 	{ 
	 options = paste(options," -maxTries", sep="")
	}
	if (is.null(noOverlapping) == FALSE) 
 	{ 
	 options = paste(options," -noOverlapping", sep="")
	}
	if (is.null(allowBeyondChromEnd) == FALSE) 
 	{ 
	 options = paste(options," -allowBeyondChromEnd", sep="")
	}

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools shuffle ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 