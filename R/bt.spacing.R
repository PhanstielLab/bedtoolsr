#' Report (last col.) the gap lengths between intervals in a file.
#' 
#' @param i <bed/gff/vcf/bam>
#' @param output Output filepath instead of returning output in R.
#' 
bt.spacing <- function(i, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c(), values=list())

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path) && !grepl("wsl", bedtools.path, ignore.case=TRUE)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools spacing ", options, " -i ", i[[1]], " > ", tempfile)
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
	temp.files <- c(tempfile, i[[2]])
	deleteTempFiles(temp.files)

	if(is.null(output))
		return(results)
}