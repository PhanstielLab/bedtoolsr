#' Makes adjacent or sliding windows across a genome or BED file.
#' 
#' @param g <genome>
#' Genome file size (see notes below).
#' Windows will be created for each chromosome in the file.
#' @param b <bed>
#' BED file (with chrom,start,end fields).
#' Windows will be created for each interval in the file.
#' Windows Output Options:
#' @param w <window_size>
#' Divide each input interval (either a chromosome or a BED interval)
#' to fixed
#' @param n <number_of_windows>
#' Divide each input interval (either a chromosome or a BED interval)
#' to fixed number of windows (i.e. same number of windows, with
#' varying window sizes).
#' @param sized windows (i.e. same number of nucleotide in each window).
#' Can be combined with
#' @param s <step_size>
#' Step size: i.e., how many base pairs to step before
#' creating a new window. Used to create "sliding" windows.
#' @param  use the source interval's name with the window number.
#' See below for usage examples.
#' @param sliding windows).
#' @param reverse
#' Reverse numbering of windows in the output, i.e. report 
#' windows in decreasing order
#' ID Naming Options:
#' @param i srcwinnum"
makewindows
 <- function(g, b, w, n, sized, s, , sliding, reverse
Reverse, i, )
{ 
	options = "" 

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools makewindows
 ", options, " -a " ,a, " -b ", b, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 

	if (file.exists(tempfile)) 
	 { 
	 file.remove(tempfile) 
	 } 
	return (results) 
}
 