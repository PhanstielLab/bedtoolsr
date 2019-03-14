#' Profiles the nucleotide content of intervals in a fasta file.
#' 
#' @param fi <fasta>
#' @param bed <bed/gff/vcf>
#' @param s Profile the sequence according to strand.
#' 
#' @param seq Print the extracted sequence
#' 
#' @param pattern Report the number of times a user-defined sequence
#'     is observed (case-sensitive).
#' 
#' @param C Ignore case when matching -pattern. By defaulty, case matters.
#' 
#' @param fullHeader Use full fasta header.
#'   - By default, only the word before the first space or tab is used.
#' 
nuc <- function(fi, bed, s = NULL, seq = NULL, pattern = NULL, C = NULL, fullHeader = NULL)
{ 
	# Required Inputs
	fi = establishPaths(input=fi,name="fi",allowRobjects=TRUE)
	bed = establishPaths(input=bed,name="bed",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("s","seq","pattern","C","fullHeader"),values= list(s,seq,pattern,C,fullHeader))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools nuc ", options, " -fi ", fi[[1]], " -bed ", bed[[1]], " > ", tempfile) 
	system(cmd) 
	results = utils::read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempFiles(c(tempfile,fi[[2]],bed[[2]]))
	return (results)
}