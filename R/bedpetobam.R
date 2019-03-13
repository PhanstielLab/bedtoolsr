#' Converts feature records to BAM format.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param mapq Set the mappinq quality for the BAM records.
#'   (INT) Default: 255
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
bedpetobam <- function(i, g, mapq = NULL, ubam = NULL)
{ 
	# Required Inputs
	i = establishPaths(input=i,name="i",allowRobjects=TRUE)
	g = establishPaths(input=g,name="g",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("mapq","ubam"),values= list(mapq,ubam))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools bedpetobam ", options, " -i ", i[[1]], " -g ", g[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempFiles(c(tempfile,i[[2]],g[[2]]))
	return (results)
}