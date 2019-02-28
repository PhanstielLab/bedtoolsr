#' Sorts a feature file in various and useful ways.
#' 
#' @param i <bed/gff/vcf>
#' @param sizeA   Sort by feature size in ascending order.
#' 
#' @param sizeD   Sort by feature size in descending order.
#' 
#' @param chrThenSizeA  Sort by chrom (asc), then feature size (asc).
#' 
#' @param chrThenSizeD  Sort by chrom (asc), then feature size (desc).
#' 
#' @param chrThenScoreA  Sort by chrom (asc), then score (asc).
#' 
#' @param chrThenScoreD  Sort by chrom (asc), then score (desc).
#' 
#' @param g Sort according to the chromosomes declared in "genome.txt"
#' 
#' @param faidx Sort according to the chromosomes declared in "names.txt"
#' 
#' @param header Print the header from the A file prior to results.
#' 
sort <- function(i, sizeA = NULL, sizeD = NULL, chrThenSizeA = NULL, chrThenSizeD = NULL, chrThenScoreA = NULL, chrThenScoreD = NULL, g = NULL, faidx = NULL, header = NULL)
{ 
	# Required Inputs
	i = establishPaths(input=i,name="i",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("sizeA","sizeD","chrThenSizeA","chrThenSizeD","chrThenScoreA","chrThenScoreD","g","faidx","header"),values= list(sizeA,sizeD,chrThenSizeA,chrThenSizeD,chrThenScoreA,chrThenScoreD,g,faidx,header))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools sort ", options, " -i ", i[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempfiles(c(tempfile,i[[2]]))
	return (results)
}