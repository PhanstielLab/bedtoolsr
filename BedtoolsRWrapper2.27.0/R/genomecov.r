#' Compute the coverage of a feature file among a genome.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param ibam  The input file is in BAM format.
#'  Note: BAM _must_ be sorted by position
#' 
#' @param d  Report the depth at each genome position (with one-based coordinates).
#'  Default behavior is to report a histogram.
#' 
#' @param dz  Report the depth at each genome position (with zero-based coordinates).
#'  Reports only non-zero positions.
#'  Default behavior is to report a histogram.
#' 
#' @param bg  Report depth in BedGraph format. For details, see:
#'  genome.ucsc.edu/goldenPath/help/bedgraph.html
#' 
#' @param bga  Report depth in BedGraph format, as above (-bg).
#'  However with this option, regions with zero 
#'  coverage are also reported. This allows one to
#'  quickly extract all regions of a genome with 0 
#'  coverage by applying: "grep -w 0$" to the output.
#' 
#' @param split  Treat "split" BAM or BED12 entries as distinct BED intervals.
#'  when computing coverage.
#'  For BAM files, this uses the CIGAR "N" and "D" operations 
#'  to infer the blocks for computing coverage.
#'  For BED12 files, this uses the BlockCount, BlockStarts, and BlockEnds
#'  fields (i.e., columns 10,11,12).
#' 
#' @param strand  Calculate coverage of intervals from a specific strand.
#'  With BED files, requires at least 6 columns (strand is column 6). 
#'  - (STRING): can be + or -
#' 
#' @param pc  Calculate coverage of pair-end fragments.
#'  Works for BAM files only
#' 
#' @param fs  Force to use provided fragment size instead of read length
#'  Works for BAM files only
#' 
#' @param du  Change strand af the mate read (so both reads from the same strand) useful for strand specific
#'  Works for BAM files only
#' 
#' @param five  Calculate coverage of 5" positions (instead of entire interval).
#' 
#' @param three  Calculate coverage of 3" positions (instead of entire interval).
#' 
#' @param max  Combine all positions with a depth >= max into
#'  a single bin in the histogram. Irrelevant
#'  for -d and -bedGraph
#'  - (INTEGER)
#' 
#' @param scale  Scale the coverage by a constant factor.
#'  Each coverage value is multiplied by this factor before being reported.
#'  Useful for normalizing coverage by, e.g., reads per million (RPM).
#'  - Default is 1.0; i.e., unscaled.
#'  - (FLOAT)
#' 
#' @param trackline Adds a UCSC/Genome-Browser track line definition in the first line of the output.
#'  - See here for more details about track line definition:
#'        http://genome.ucsc.edu/goldenPath/help/bedgraph.html
#'  - NOTE: When adding a trackline definition, the output BedGraph can be easily
#'        uploaded to the Genome Browser as a custom track,
#'        BUT CAN NOT be converted into a BigWig file (w/o removing the first line).
#' 
#' @param trackopts Writes additional track line definition parameters in the first line.
#'  - Example:
#'     -trackopts 'name="My Track" visibility=2 color=255,30,30'
#'     Note the use of single-quotes if you have spaces in your parameters.
#'  - (TEXT)
#' 
genomecov <- function(i, g, ibam = NULL, d = NULL, dz = NULL, bg = NULL, bga = NULL, split = NULL, strand = NULL, pc = NULL, fs = NULL, du = NULL, five = NULL, three = NULL, max = NULL, scale = NULL, trackline = NULL, trackopts = NULL)
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
 
			if (!is.null(ibam)) {
			options = paste(options," -ibam")
			if(is.character(ibam) || is.numeric(ibam)) {
			options = paste(options, " ", ibam)
			}	
			}
			 
			if (!is.null(d)) {
			options = paste(options," -d")
			if(is.character(d) || is.numeric(d)) {
			options = paste(options, " ", d)
			}	
			}
			 
			if (!is.null(dz)) {
			options = paste(options," -dz")
			if(is.character(dz) || is.numeric(dz)) {
			options = paste(options, " ", dz)
			}	
			}
			 
			if (!is.null(bg)) {
			options = paste(options," -bg")
			if(is.character(bg) || is.numeric(bg)) {
			options = paste(options, " ", bg)
			}	
			}
			 
			if (!is.null(bga)) {
			options = paste(options," -bga")
			if(is.character(bga) || is.numeric(bga)) {
			options = paste(options, " ", bga)
			}	
			}
			 
			if (!is.null(split)) {
			options = paste(options," -split")
			if(is.character(split) || is.numeric(split)) {
			options = paste(options, " ", split)
			}	
			}
			 
			if (!is.null(strand)) {
			options = paste(options," -strand")
			if(is.character(strand) || is.numeric(strand)) {
			options = paste(options, " ", strand)
			}	
			}
			 
			if (!is.null(pc)) {
			options = paste(options," -pc")
			if(is.character(pc) || is.numeric(pc)) {
			options = paste(options, " ", pc)
			}	
			}
			 
			if (!is.null(fs)) {
			options = paste(options," -fs")
			if(is.character(fs) || is.numeric(fs)) {
			options = paste(options, " ", fs)
			}	
			}
			 
			if (!is.null(du)) {
			options = paste(options," -du")
			if(is.character(du) || is.numeric(du)) {
			options = paste(options, " ", du)
			}	
			}
			 
			if (!is.null(five)) {
			options = paste(options," -5")
			if(is.character(five) || is.numeric(five)) {
			options = paste(options, " ", five)
			}	
			}
			 
			if (!is.null(three)) {
			options = paste(options," -3")
			if(is.character(three) || is.numeric(three)) {
			options = paste(options, " ", three)
			}	
			}
			 
			if (!is.null(max)) {
			options = paste(options," -max")
			if(is.character(max) || is.numeric(max)) {
			options = paste(options, " ", max)
			}	
			}
			 
			if (!is.null(scale)) {
			options = paste(options," -scale")
			if(is.character(scale) || is.numeric(scale)) {
			options = paste(options, " ", scale)
			}	
			}
			 
			if (!is.null(trackline)) {
			options = paste(options," -trackline")
			if(is.character(trackline) || is.numeric(trackline)) {
			options = paste(options, " ", trackline)
			}	
			}
			 
			if (!is.null(trackopts)) {
			options = paste(options," -trackopts")
			if(is.character(trackopts) || is.numeric(trackopts)) {
			options = paste(options, " ", trackopts)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools2/bin/bedtools genomecov ", options, " -i ", i, " -g ", g, " > ", tempfile) 
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
