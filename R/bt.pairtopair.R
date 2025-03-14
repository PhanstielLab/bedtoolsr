#' Report overlaps between two paired-end BED files (BEDPE).
#' 
#' @param a <BEDPE>
#' @param b <BEDPE>
#' @param f Minimum overlap required as fraction of A (e.g. 0.05).
#'   Default is 1E-9 (effectively 1bp).
#' 
#' @param type Approach to reporting overlaps between A and B.
#'   neither Report overlaps if neither end of A overlaps B.
#'   either Report overlaps if either ends of A overlap B.
#'   both Report overlaps if both ends of A overlap B.
#'   notboth Report overlaps if one or neither of A's overlap B.
#'   - Default = both.
#' 
#' @param slop The amount of slop (in b.p.). to be added to each footprint of A.
#'   *Note*: Slop is subtracted from start1 and start2
#'     and added to end1 and end2.
#'   - Default = 0.
#' 
#' @param ss Add slop based to each BEDPE footprint based on strand.
#'   - If strand is "+", slop is only added to the end coordinates.
#'   - If strand is "-", slop is only added to the start coordinates.
#'   - By default, slop is added in both directions.
#' 
#' @param is Ignore strands when searching for overlaps.
#'   - By default, strands are enforced.
#' 
#' @param rdn Require the hits to have different names (i.e. avoid self-hits).
#'   - By default, same names are allowed.
#' 
#' @param output Output filepath instead of returning output in R.
#' 
bt.pairtopair <- function(a, b, f = NULL, type = NULL, slop = NULL, ss = NULL, is = NULL, rdn = NULL, output = NULL)
{
	# Required Inputs
	a <- establishPaths(input=a, name="a", allowRobjects=TRUE)
	b <- establishPaths(input=b, name="b", allowRobjects=TRUE)

	options <- ""

	# Options
	options <- createOptions(names=c("f", "type", "slop", "ss", "is", "rdn"), values=list(f, type, slop, ss, is, rdn))

	# establish output file 
	tempfile <- tempfile("bedtoolsr", fileext=".txt")
	tempfile <- gsub("\\", "/", tempfile, fixed=TRUE)
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path) && !grepl("wsl", bedtools.path, ignore.case=TRUE)) bedtools.path <- paste0(bedtools.path, "/")
	cmd <- paste0(bedtools.path, "bedtools pairtopair ", options, " -a ", a[[1]], " -b ", b[[1]], " > ", tempfile)
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
	temp.files <- c(tempfile, a[[2]], b[[2]])
	deleteTempFiles(temp.files)

	if(is.null(output))
		return(results)
}