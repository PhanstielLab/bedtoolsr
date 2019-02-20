#' Annotates the depth & breadth of coverage of features from mult. files
#' on the intervals in -i.
#' 
#' @param i <bed/gff/vcf>
#' @param files FILE1 FILE2..FILEn
#' @param S Require different strandedness.  That is, only count overlaps
#' on the _opposite_ strand.
#' - By default, overlaps are counted without respect to strand.
#' 
#' @param both Report the counts followed by the  percent coverage.
#' - Default is to report the fraction of -i covered by each file.
#' 
#' @param counts Report the count of features in each file that overlap -i.
#' - Default is to report the fraction of -i covered by each file.
#' 
#' @param s Require same strandedness.  That is, only counts overlaps
#' on the _same_ strand.
#' - By default, overlaps are counted without respect to strand.
#' 
#' @param names A list of names (one / file) to describe each file in -i.
#' These names will be printed as a header line.
#' 
annotate <- function(i, files, S = NULL, both = NULL, counts = NULL, s = NULL, names = NULL)
{ 
  # Required Inputs
  i = establishpaths(input=i,name="i")
  files = establishpaths(input=files,name="files")
  
  # Options
  options = createOptions(names = c("S","both","counts","s","names"),
                          values= c(S,both,counts,s,names))
  
  # Establish output file 
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





