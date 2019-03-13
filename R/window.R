#' Examines a "window" around each feature in A and
#' reports all features in B that overlap the window. For each
#' overlap the entire entry in A and B are reported.
#' 
#' @param a <bed/gff/vcf>
#' @param b <bed/gff/vcf>
#' @param abam The A input file is in BAM format.  Output will be BAM as well. Replaces -a.
#' 
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
#' @param bed When using BAM input (-abam), write output as BED. The default
#'   is to write output in BAM when using -abam.
#' 
#' @param w Base pairs added upstream and downstream of each entry
#'   in A when searching for overlaps in B.
#'   - Creates symterical "windows" around A.
#'   - Default is 1000 bp.
#'   - (INTEGER)
#' 
#' @param l Base pairs added upstream (left of) of each entry
#'   in A when searching for overlaps in B.
#'   - Allows one to define assymterical "windows".
#'   - Default is 1000 bp.
#'   - (INTEGER)
#' 
#' @param r Base pairs added downstream (right of) of each entry
#'   in A when searching for overlaps in B.
#'   - Allows one to define assymterical "windows".
#'   - Default is 1000 bp.
#'   - (INTEGER)
#' 
#' @param sw Define -l and -r based on strand.  For example if used, -l 500
#'   for a negative-stranded feature will add 500 bp downstream.
#'   - Default = disabled.
#' 
#' @param sm Only report hits in B that overlap A on the _same_ strand.
#'   - By default, overlaps are reported without respect to strand.
#' 
#' @param Sm Only report hits in B that overlap A on the _opposite_ strand.
#'   - By default, overlaps are reported without respect to strand.
#' 
#' @param u Write the original A entry _once_ if _any_ overlaps found in B.
#'   - In other words, just report the fact >=1 hit was found.
#' 
#' @param c For each entry in A, report the number of overlaps with B.
#'   - Reports 0 for A entries that have no overlap with B.
#'   - Overlaps restricted by -w, -l, and -r.
#' 
#' @param v Only report those entries in A that have _no overlaps_ with B.
#'   - Similar to "grep -v."
#' 
#' @param header Print the header from the A file prior to results.
#' 
window <- function(a, b, abam = NULL, ubam = NULL, bed = NULL, w = NULL, l = NULL, r = NULL, sw = NULL, sm = NULL, Sm = NULL, u = NULL, c = NULL, v = NULL, header = NULL)
{ 
	# Required Inputs
	a = establishPaths(input=a,name="a",allowRobjects=TRUE)
	b = establishPaths(input=b,name="b",allowRobjects=TRUE)

	options = "" 

	# Options
	options = createOptions(names = c("abam","ubam","bed","w","l","r","sw","sm","Sm","u","c","v","header"),values= list(abam,ubam,bed,w,l,r,sw,sm,Sm,u,c,v,header))

	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools window ", options, " -a ", a[[1]], " -b ", b[[1]], " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t")

	# Delete temp files 
	deleteTempFiles(c(tempfile,a[[2]],b[[2]]))
	return (results)
}