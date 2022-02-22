#' Mask a fasta file based on feature coordinates.
#' 
#' @param fi <fasta>
#' @param fo <fasta>
#' @param bed <bed/gff/vcf>
#' @param soft Enforce "soft" masking.
#'     Mask with lower-case bases, instead of masking with Ns.
#' 
#' @param mc Replace masking character.
#'     Use another character, instead of masking with Ns.
#' 
#' @param fullHeader Use full fasta header.
#'     By default, only the word before the first space or tab
#'     is used.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.maskfasta <- function(fi, fo, bed, soft = NULL, mc = NULL, fullHeader = NULL, output = NULL)
{
	# Required Inputs
	fi <- establishPaths(input=fi, name="fi", allowRobjects=TRUE)
	fo <- establishPaths(input=fo, name="fo", allowRobjects=TRUE)
	bed <- establishPaths(input=bed, name="bed", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("soft", "mc", "fullHeader"), values=list(soft, mc, fullHeader))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools maskfasta ", options, " -fi ", fi[[1]], " -fo ", fo[[1]], " -bed ", bed[[1]], " > ", tempfile)
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
	deleteTempFiles(c(tempfile, fi[[2]], fo[[2]], bed[[2]]))

	if(is.null(output))
		return(results)
}