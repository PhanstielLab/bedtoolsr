#' Returns the base pair complement of a feature file.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
complement <- function(i, g)
{ 
	# Required Inputs
	i = establishPaths(input=i,name="i",allowRobjects=TRUE)
	g = establishPaths(input=g,name="g",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c(),values= list())

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools complement ", options, " -i ", i[[1]], " -g ", g[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempfiles(c(tempfile,i[[2]],g[[2]]))
	return (results)
}