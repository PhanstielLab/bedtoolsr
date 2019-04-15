#' Compute the coverage of a feature file among a genome.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param ibam The input file is in BAM format.
#'     Note: BAM _must_ be sorted by position
#' 
#' @param d Report the depth at each genome position (with one-based coordinates).
#'     Default behavior is to report a histogram.
#' 
#' @param dz Report the depth at each genome position (with zero-based coordinates).
#'     Reports only non-zero positions.
#'     Default behavior is to report a histogram.
#' 
#' @param bg Report depth in BedGraph format. For details, see:
#'     genome.ucsc.edu/goldenPath/help/bedgraph.html
#' 
#' @param bga Report depth in BedGraph format, as above (-bg).
#'     However with this option, regions with zero 
#'     coverage are also reported. This allows one to
#'     quickly extract all regions of a genome with 0 
#'     coverage by applying: "grep -w 0$" to the output.
#' 
#' @param split Treat "split" BAM or BED12 entries as distinct BED intervals.
#'     when computing coverage.
#'     For BAM files, this uses the CIGAR "N" and "D" operations 
#'     to infer the blocks for computing coverage.
#'     For BED12 files, this uses the BlockCount, BlockStarts, and BlockEnds
#'     fields (i.e., columns 10,11,12).
#' 
#' @param strand Calculate coverage of intervals from a specific strand.
#'     With BED files, requires at least 6 columns (strand is column 6). 
#'     - (STRING): can be + or -
#' 
#' @param pc Calculate coverage of pair-end fragments.
#'     Works for BAM files only
#' 
#' @param fs Force to use provided fragment size instead of read length
#'     Works for BAM files only
#' 
#' @param du Change strand af the mate read (so both reads from the same strand) useful for strand specific
#'     Works for BAM files only
#' 
#' @param five Calculate coverage of 5" positions (instead of entire interval).
#' 
#' @param three Calculate coverage of 3" positions (instead of entire interval).
#' 
#' @param max Combine all positions with a depth >= max into
#'     a single bin in the histogram. Irrelevant
#'     for -d and -bedGraph
#'     - (INTEGER)
#' 
#' @param scale Scale the coverage by a constant factor.
#'     Each coverage value is multiplied by this factor before being reported.
#'     Useful for normalizing coverage by, e.g., reads per million (RPM).
#'     - Default is 1.0; i.e., unscaled.
#'     - (FLOAT)
#' 
#' @param trackline Adds a UCSC/Genome-Browser track line definition in the first line of the output.
#'     - See here for more details about track line definition:
#'           http://genome.ucsc.edu/goldenPath/help/bedgraph.html
#'     - NOTE: When adding a trackline definition, the output BedGraph can be easily
#'           uploaded to the Genome Browser as a custom track,
#'           BUT CAN NOT be converted into a BigWig file (w/o removing the first line).
#' 
#' @param trackopts Writes additional track line definition parameters in the first line.
#'     - Example:
#'        -trackopts 'name="My Track" visibility=2 color=255,30,30'
#'        Note the use of single-quotes if you have spaces in your parameters.
#'     - (TEXT)
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.genomecov <- function(i, g, ibam = NULL, d = NULL, dz = NULL, bg = NULL, bga = NULL, split = NULL, strand = NULL, pc = NULL, fs = NULL, du = NULL, five = NULL, three = NULL, max = NULL, scale = NULL, trackline = NULL, trackopts = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)
	g <- establishPaths(input=g, name="g", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("ibam", "d", "dz", "bg", "bga", "split", "strand", "pc", "fs", "du", "5", "3", "max", "scale", "trackline", "trackopts"), values=list(ibam, d, dz, bg, bga, split, strand, pc, fs, du, five, three, max, scale, trackline, trackopts))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools genomecov ", options, " -i ", i[[1]], " -g ", g[[1]], " > ", tempfile)
	system(cmd)
	if(!is.null(output)) {
		if(file.info(tempfile)$size > 0)
			file.copy(tempfile, output)
	} else {
		if(file.info(tempfile)$size > 0)
			results <- utils::read.table(tempfile, header=FALSE, sep="\t")
		else
			results <- data.frame()
	}

	# Delete temp files
	deleteTempFiles(c(tempfile, i[[2]], g[[2]]))

	if(is.null(output))
		return(results)
}