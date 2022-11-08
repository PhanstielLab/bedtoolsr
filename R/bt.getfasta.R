#' Extract DNA sequences from a fasta file based on feature coordinates.
#' 
#' @param fi <fasta>
#' @param bed <bed/gff/vcf>
#' @param fo Output file (opt., default is STDOUT
#' 
#' @param name Use the name field and coordinates for the FASTA header
#' 
#' @param nameplus (deprecated) Use the name field and coordinates for the FASTA header
#' 
#' @param nameOnly Use the name field for the FASTA header
#' 
#' @param split Given BED12 fmt., extract and concatenate the sequences
#'     from the BED "blocks" (e.g., exons)
#' 
#' @param tab Write output in TAB delimited format.
#' 
#' @param bedOut Report extract sequences in a tab-delimited BED format instead of in FASTA format.
#'     - Default is FASTA format.
#' 
#' @param s Force strandedness. If the feature occupies the antisense,
#'     strand, the sequence will be reverse complemented.
#'     - By default, strand information is ignored.
#' 
#' @param fullHeader Use full fasta header.
#'     - By default, only the word before the first space or tab 
#'     is used.
#' 
#' @param rna The FASTA is RNA not DNA. Reverse complementation handled accordingly.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.getfasta <- function(fi, bed, fo = NULL, name = NULL, nameplus = NULL, nameOnly = NULL, split = NULL, tab = NULL, bedOut = NULL, s = NULL, fullHeader = NULL, rna = NULL, output = NULL)
{
	# Required Inputs
	fi <- establishPaths(input=fi, name="fi", allowRobjects=TRUE)
	bed <- establishPaths(input=bed, name="bed", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("fo", "name", "name+", "nameOnly", "split", "tab", "bedOut", "s", "fullHeader", "rna"), values=list(fo, name, nameplus, nameOnly, split, tab, bedOut, s, fullHeader, rna))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools getfasta ", options, " -fi ", fi[[1]], " -bed ", bed[[1]], " > ", tempfile)
	if(.Platform$OS.type == "windows") shell(cmd) else system(cmd)
	if(!is.null(output)) {
		if(file.info(tempfile)$size > 0)
			file.copy(tempfile, output)
	} else {
		if(file.info(tempfile)$size > 0)
			results <- utils::read.table(tempfile, header=FALSE, sep="\t", quote='')
		else
			results <- data.frame()
	}

	# Delete temp files
	temp.files <- c(tempfile, fi[[2]], bed[[2]])
	deleteTempFiles(temp.files)

	if(is.null(output))
		return(results)
}