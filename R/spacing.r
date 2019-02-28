#' Report (last col.) the gap lengths between intervals in a file.
#' 
#' @param i <bed/gff/vcf/bam>
spacing <- function(i)
{ 
	# Required Inputs
	i = establishPaths(input=i,name="i",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c(),values= list())

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools spacing ", options, " -i ", i[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempfiles(c(tempfile,i[[2]]))
	return (results)
}