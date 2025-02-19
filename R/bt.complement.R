#' Returns the base pair complement of a feature file.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param L Limit output to solely the chromosomes with records in the input file.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.complement <- function(i, g, L = NULL, output = NULL)
{
	# Required Inputs
	i <- establishPaths(input=i, name="i", allowRobjects=TRUE)
	g <- establishPaths(input=g, name="g", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("L"), values=list(L))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path) && !grepl("wsl", bedtools.path, ignore.case=TRUE)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools complement ", options, " -i ", i[[1]], " -g ", g[[1]], " > ", tempfile)
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
	temp.files <- c(tempfile, i[[2]], g[[2]])
	deleteTempFiles(temp.files)

	if(is.null(output))
		return(results)
}