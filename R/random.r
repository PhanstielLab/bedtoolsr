#' Generate random intervals among a genome.
#' 
#' @param g <genome>
#' @param seed Supply an integer seed for the shuffling.
#' - By default, the seed is chosen automatically.
#' - (INTEGER)
#' 
#' @param l The length of the intervals to generate.
#' - Default = 100.
#' - (INTEGER)
#' 
#' @param n The number of intervals to generate.
#' - Default = 1,000,000.
#' - (INTEGER)
#' 
random <- function(g, seed = NULL, l = NULL, n = NULL)
{ 

			if (!is.character(g) && !is.numeric(g)) {
			gTable = "~/Desktop/gTable.txt"
			write.table(g, gTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			g=gTable } 
			
		options = "" 
 
			if (!is.null(seed)) {
			options = paste(options," -seed")
			if(is.character(seed) || is.numeric(seed)) {
			options = paste(options, " ", seed)
			}	
			}
			 
			if (!is.null(l)) {
			options = paste(options," -l")
			if(is.character(l) || is.numeric(l)) {
			options = paste(options, " ", l)
			}	
			}
			 
			if (!is.null(n)) {
			options = paste(options," -n")
			if(is.character(n) || is.numeric(n)) {
			options = paste(options, " ", n)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste(getOption("bedtools.path"), "bedtools random ", options, " -g ", g, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("gTable")) { 
		file.remove (gTable)
		} 
