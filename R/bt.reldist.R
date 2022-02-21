#' Calculate the relative distance distribution b/w two feature files.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param detail Report the relativedistance for each interval in A
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.reldist <- function(a, b, detail = NULL, output = NULL)
{
	# Required Inputs
	a <- establishPaths(input=a, name="a", allowRobjects=TRUE)
	b <- establishPaths(input=b, name="b", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("detail"), values=list(detail))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools reldist ", options, " -a ", a[[1]], " -b ", b[[1]], " > ", tempfile)
	system(cmd)
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
	deleteTempFiles(c(tempfile, a[[2]], b[[2]]))

	if(is.null(output))
		return(results)
}