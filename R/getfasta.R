#' Extract DNA sequences from a fasta file based on feature coordinates.
#' 
#' @param fi <fasta>
#' @param bed <bed/gff/vcf>
#' @param fo Output file (opt., default is STDOUT
#' 
#' @param name Use the name field for the FASTA header
#' 
#' @param nameplus Use the name field and coordinates for the FASTA header
#' 
#' @param split given BED12 fmt., extract and concatenate the sequences
#'   from the BED "blocks" (e.g., exons)
#' 
#' @param tab Write output in TAB delimited format.
#'   - Default is FASTA format.
#' 
#' @param s Force strandedness. If the feature occupies the antisense,
#'   strand, the sequence will be reverse complemented.
#'   - By default, strand information is ignored.
#' 
#' @param fullHeader Use full fasta header.
#'   - By default, only the word before the first space or tab 
#'   is used.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
getfasta <- function(fi, bed, fo = NULL, name = NULL, nameplus = NULL, split = NULL, tab = NULL, s = NULL, fullHeader = NULL, output = NULL)
{
	# Required Inputs
	fi <- establishPaths(input=fi, name="fi", allowRobjects=TRUE)
	bed <- establishPaths(input=bed, name="bed", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("fo", "name", "name+", "split", "tab", "s", "fullHeader"), values=list(fo, name, nameplus, split, tab, s, fullHeader))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools getfasta ", options, " -fi ", fi[[1]], " -bed ", bed[[1]], " > ", tempfile)
	system(cmd)
	if(!is.null(output))
		file.copy(tempfile, output)
	else
		results <- utils::read.table(tempfile, header=FALSE, sep="\t")

	# Delete temp files
	deleteTempFiles(c(tempfile, fi[[2]], bed[[2]]))

	if(is.null(output))
		return(results)
}