#' Converts feature records to BAM format.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param mapq Set the mappinq quality for the BAM records.
#' (INT) Default: 255
#' 
#' @param bed12 The BED file is in BED12 format.  The BAM CIGAR
#' string will reflect BED "blocks".
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
bedtobam <- function(i, g, mapq = NULL, bed12 = NULL, ubam = NULL)
{ 
	# Required Inputs
	i = establishPaths(input=i,name="i")
	g = establishPaths(input=g,name="g")

	options = "" 

	# Options
	options = createOptions(names = c("mapq","bed12","ubam"),values= list(mapq,bed12,ubam))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools bedtobam ", options, " -i ", i[[1]], " -g ", g[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempfiles(c(tempfile,i[[2]],g[[2]]))
	return (results)
}