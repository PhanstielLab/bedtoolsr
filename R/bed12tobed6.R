#' Splits BED12 features into discrete BED6 features.
#' 
#' @param i <bed12>
#' @param n Force the score to be the (1-based) block number from the BED12.
#' 
bed12tobed6 <- function(i, n = NULL)
{ 
	# Required Inputs
	i = establishPaths(input=i,name="i",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("n"),values= list(n))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools bed12tobed6 ", options, " -i ", i[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempFiles(c(tempfile,i[[2]]))
	return (results)
}