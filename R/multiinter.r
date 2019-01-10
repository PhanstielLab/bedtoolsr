#' Identifies common intervals among multiple
#' BED/GFF/VCF files.
#' 
#' @param i FILE1 FILE2 .. FILEn
#' Requires that each interval file is sorted by chrom/start.
#' @param g  Use genome file to calculate empty regions.
#'  - STRING.
#' 
#' @param header  Print a header line.
#'  (chrom/start/end + names of each file).
#' 
#' @param filler Use TEXT when representing intervals having no value.
#'  - Default is '0', but you can use 'N/A' or any text.
#' 
#' @param cluster Invoke Ryan Layers's clustering algorithm.
#' 
#' @param names  A list of names (one/file) to describe each file in -i.
#'  These names will be printed in the header line.
#' 
#' @param empty  Report empty regions (i.e., start/end intervals w/o
#'  values in all files).
#'  - Requires the '-g FILE' parameter.
#' 
#' @param examples Show detailed usage examples.
#' 
multiinter <- function(i, g = NULL, header = NULL, filler = NULL, cluster = NULL, names = NULL, empty = NULL, examples = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
		options = "" 
 
			if (!is.null(g)) {
			options = paste(options," -g")
			if(is.character(g) || is.numeric(g)) {
			options = paste(options, " ", g)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(filler)) {
			options = paste(options," -filler")
			if(is.character(filler) || is.numeric(filler)) {
			options = paste(options, " ", filler)
			}	
			}
			 
			if (!is.null(cluster)) {
			options = paste(options," -cluster")
			if(is.character(cluster) || is.numeric(cluster)) {
			options = paste(options, " ", cluster)
			}	
			}
			 
			if (!is.null(names)) {
			options = paste(options," -names")
			if(is.character(names) || is.numeric(names)) {
			options = paste(options, " ", names)
			}	
			}
			 
			if (!is.null(empty)) {
			options = paste(options," -empty")
			if(is.character(empty) || is.numeric(empty)) {
			options = paste(options, " ", empty)
			}	
			}
			 
			if (!is.null(examples)) {
			options = paste(options," -examples")
			if(is.character(examples) || is.numeric(examples)) {
			options = paste(options, " ", examples)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools multiinter ", options, " -i ", i, " > ", tempfile) 
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
