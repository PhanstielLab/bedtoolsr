#' Generate random intervals among a genome.
#' 
#' @param g <genome>
#' @param l The length of the intervals to generate.
#'   - Default = 100.
#'   - (INTEGER)
#' 
#' @param n The number of intervals to generate.
#'   - Default = 1,000,000.
#'   - (INTEGER)
#' 
#' @param seed Supply an integer seed for the shuffling.
#'   - By default, the seed is chosen automatically.
#'   - (INTEGER)
#' 
random <- function(g, l = NULL, n = NULL, seed = NULL)
{ 
	# Required Inputs
	g = establishPaths(input=g,name="g",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("l","n","seed"),values= list(l,n,seed))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools random ", options, " -g ", g[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempFiles(c(tempfile,g[[2]]))
	return (results)
}