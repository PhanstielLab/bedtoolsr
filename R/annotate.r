#' Annotates the depth & breadth of coverage of features from mult. files
#' on the intervals in -i.
#' 
#' @param i <bed/gff/vcf>
#' @param files FILE1 FILE2..FILEn
#' @param names A list of names (one / file) to describe each file in -i.
#'   These names will be printed as a header line.
#' 
#' @param counts Report the count of features in each file that overlap -i.
#'   - Default is to report the fraction of -i covered by each file.
#' 
#' @param both Report the counts followed by the  percent coverage.
#'   - Default is to report the fraction of -i covered by each file.
#' 
#' @param s Require same strandedness.  That is, only counts overlaps
#'   on the _same_ strand.
#'   - By default, overlaps are counted without respect to strand.
#' 
#' @param S Require different strandedness.  That is, only count overlaps
#'   on the _opposite_ strand.
#'   - By default, overlaps are counted without respect to strand.
#' 
annotate <- function(i, files, names = NULL, counts = NULL, both = NULL, s = NULL, S = NULL)
{ 
	# Required Inputs
	i = establishPaths(input=i,name="i",allowRobjects=TRUE)
	files = establishPaths(input=files,name="files",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("names","counts","both","s","S"),values= list(names,counts,both,s,S))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools annotate ", options, " -i ", i[[1]], " -files ", files[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempfiles(c(tempfile,i[[2]],files[[2]]))
	return (results)
}