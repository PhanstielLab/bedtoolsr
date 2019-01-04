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
#' randomized locus. For example, -f 0.10 allows up to 10 percent
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

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
			if (!is.character(g) && !is.numeric(g)) {
			gTable = "~/Desktop/gTable.txt"
			write.table(g, gTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			g=gTable } 
			
		options = "" 
 
			if (!is.null(excl)) {
			options = paste(options," -excl")
			if(is.character(excl) || is.numeric(excl)) {
			options = paste(options, " ", excl)
			}	
			}
			 
			if (!is.null(incl)) {
			options = paste(options," -incl")
			if(is.character(incl) || is.numeric(incl)) {
			options = paste(options, " ", incl)
			}	
			}
			 
			if (!is.null(chrom)) {
			options = paste(options," -chrom")
			if(is.character(chrom) || is.numeric(chrom)) {
			options = paste(options, " ", chrom)
			}	
			}
			 
			if (!is.null(seed)) {
			options = paste(options," -seed")
			if(is.character(seed) || is.numeric(seed)) {
			options = paste(options, " ", seed)
			}	
			}
			 
			if (!is.null(f)) {
			options = paste(options," -f")
			if(is.character(f) || is.numeric(f)) {
			options = paste(options, " ", f)
			}	
			}
			 
			if (!is.null(chromFirst)) {
			options = paste(options," -chromFirst")
			if(is.character(chromFirst) || is.numeric(chromFirst)) {
			options = paste(options, " ", chromFirst)
			}	
			}
			 
			if (!is.null(bedpe)) {
			options = paste(options," -bedpe")
			if(is.character(bedpe) || is.numeric(bedpe)) {
			options = paste(options, " ", bedpe)
			}	
			}
			 
			if (!is.null(maxTries)) {
			options = paste(options," -maxTries")
			if(is.character(maxTries) || is.numeric(maxTries)) {
			options = paste(options, " ", maxTries)
			}	
			}
			 
			if (!is.null(noOverlapping)) {
			options = paste(options," -noOverlapping")
			if(is.character(noOverlapping) || is.numeric(noOverlapping)) {
			options = paste(options, " ", noOverlapping)
			}	
			}
			 
			if (!is.null(allowBeyondChromEnd)) {
			options = paste(options," -allowBeyondChromEnd")
			if(is.character(allowBeyondChromEnd) || is.numeric(allowBeyondChromEnd)) {
			options = paste(options, " ", allowBeyondChromEnd)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools shuffle ", options, " -i ", i, " -g ", g, " > ", tempfile) 
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
 
		if(exists("gTable")) { 
		file.remove (gTable)
		} 
