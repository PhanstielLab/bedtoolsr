#' Randomly permute the locations of a feature file among a genome.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param excl A BED/GFF/VCF file of coordinates in which features in -i
#'   should not be placed (e.g. gaps.bed).
#' 
#' @param incl Instead of randomly placing features in a genome, the -incl
#'   options defines a BED/GFF/VCF file of coordinates in which 
#'   features in -i should be randomly placed (e.g. genes.bed). 
#'   Larger -incl intervals will contain more shuffled regions. 
#'   This method DISABLES -chromFirst. 
#' 
#' @param chrom Keep features in -i on the same chromosome.
#'   - By default, the chrom and position are randomly chosen.
#'   - NOTE: Forces use of -chromFirst (see below).
#' 
#' @param seed Supply an integer seed for the shuffling.
#'   - By default, the seed is chosen automatically.
#'   - (INTEGER)
#' 
#' @param f Maximum overlap (as a fraction of the -i feature) with an -excl
#'   feature that is tolerated before searching for a new, 
#'   randomized locus. For example, -f 0.10 allows up to 10 percent
#'   of a randomized feature to overlap with a given feature
#'   in the -excl file. **Cannot be used with -incl file.**
#'   - Default is 1E-9 (i.e., 1bp).
#'   - FLOAT (e.g. 0.50)
#' 
#' @param chromFirst 
#'   Instead of choosing a position randomly among the entire
#'   genome (the default), first choose a chrom randomly, and then
#'   choose a random start coordinate on that chrom.  This leads
#'   to features being ~uniformly distributed among the chroms,
#'   as opposed to features being distribute as a function of chrom size.
#' 
#' @param bedpe Indicate that the A file is in BEDPE format.
#' 
#' @param maxTries 
#'   Max. number of attempts to find a home for a shuffled interval
#'   in the presence of -incl or -excl.
#'   Default = 1000.
#' 
#' @param noOverlapping 
#'   Don't allow shuffled intervals to overlap.
#' 
#' @param allowBeyondChromEnd 
#'   Allow shuffled intervals to be relocated to a position
#'   in which the entire original interval cannot fit w/o exceeding
#'   the end of the chromosome.  In this case, the end coordinate of the
#'   shuffled interval will be set to the chromosome's length.
#'   By default, an interval's original length must be fully-contained
#'   within the chromosome.
#' 
shuffle <- function(i, g, excl = NULL, incl = NULL, chrom = NULL, seed = NULL, f = NULL, chromFirst = NULL, bedpe = NULL, maxTries = NULL, noOverlapping = NULL, allowBeyondChromEnd = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)
	g <- establishPaths(input=g, name="g", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("excl", "incl", "chrom", "seed", "f", "chromFirst", "bedpe", "maxTries", "noOverlapping", "allowBeyondChromEnd"), values=list(excl, incl, chrom, seed, f, chromFirst, bedpe, maxTries, noOverlapping, allowBeyondChromEnd))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools shuffle ", options, " -i ", i[[1]], " -g ", g[[1]], " > ", tempfile)
	system(cmd)
	results <- utils::read.table(tempfile, header=FALSE, sep="\t")

	# Delete temp files
	deleteTempFiles(c(tempfile, i[[2]], g[[2]]))

	return(results)
}