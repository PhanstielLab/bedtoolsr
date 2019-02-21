#' Clusters overlapping/nearby BED/GFF/VCF intervals.
#' 
#' @param i <bed/gff/vcf>
#' @param s Force strandedness.  That is, only merge features
#' that are the same strand.
#' - By default, merging is done without respect to strand.
#' 
#' @param d Maximum distance between features allowed for features
#' to be merged.
#' - Def. 0. That is, overlapping & book-ended features are merged.
#' - (INTEGER)
#' 
cluster <- function(i, s = NULL, d = NULL)
{ 
	# Required Inputs
	i = establishPaths(input=i,name="i")

	options = "" 

	# Options
	options = createOptions(names = c("s","d"),values= list(s,d))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools cluster ", options, " -i ", i[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempfiles(c(tempfile,i[[2]]))
	return (results)
}