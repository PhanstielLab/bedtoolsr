#' Summarizes a dataset column based upon
#' common column groupings. Akin to the SQL "group by" command.
#' 
#' @param c 
#' @param o 
#' @param g 
#' @param full  Print all columns from input file.  The first line in the group is used.
#'  Default: print only grouped columns.
#' 
#' @param i  Input file. Assumes "stdin" if omitted.
#' 
#' @param inheader Input file has a header line - the first line will be ignored.
#' 
#' @param delim Specify a custom delimiter for the collapse operations.
#' - Example: -delim "|"
#' - Default: ",".
#' 
#' @param outheader Print header line in the output, detailing the column names. 
#'  If the input file has headers (-inheader), the output file
#'  will use the input's column names.
#'  If the input file has no headers, the output file
#'  will use "col_1", "col_2", etc. as the column names.
#' 
#' @param ignorecase Group values regardless of upper/lower case.
#' 
#' @param header  same as '-inheader -outheader'
#' 
#' @param prec Sets the decimal precision for output (Default: 5)
#' 
groupby <- function(c, o, g, full = NULL, i = NULL, inheader = NULL, delim = NULL, outheader = NULL, ignorecase = NULL, header = NULL, prec = NULL)
{ 

			if (!is.character(c) && !is.numeric(c)) {
			cTable = "~/Desktop/cTable.txt"
			write.table(c, cTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			c=cTable } 
			
			if (!is.character(o) && !is.numeric(o)) {
			oTable = "~/Desktop/oTable.txt"
			write.table(o, oTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			o=oTable } 
			
			if (!is.character(g) && !is.numeric(g)) {
			gTable = "~/Desktop/gTable.txt"
			write.table(g, gTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			g=gTable } 
			
		options = "" 
 
			if (!is.null(full)) {
			options = paste(options," -full")
			if(is.character(full) || is.numeric(full)) {
			options = paste(options, " ", full)
			}	
			}
			 
			if (!is.null(i)) {
			options = paste(options," -i")
			if(is.character(i) || is.numeric(i)) {
			options = paste(options, " ", i)
			}	
			}
			 
			if (!is.null(inheader)) {
			options = paste(options," -inheader")
			if(is.character(inheader) || is.numeric(inheader)) {
			options = paste(options, " ", inheader)
			}	
			}
			 
			if (!is.null(delim)) {
			options = paste(options," -delim")
			if(is.character(delim) || is.numeric(delim)) {
			options = paste(options, " ", delim)
			}	
			}
			 
			if (!is.null(outheader)) {
			options = paste(options," -outheader")
			if(is.character(outheader) || is.numeric(outheader)) {
			options = paste(options, " ", outheader)
			}	
			}
			 
			if (!is.null(ignorecase)) {
			options = paste(options," -ignorecase")
			if(is.character(ignorecase) || is.numeric(ignorecase)) {
			options = paste(options, " ", ignorecase)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(prec)) {
			options = paste(options," -prec")
			if(is.character(prec) || is.numeric(prec)) {
			options = paste(options, " ", prec)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools groupby ", options, " -c ", c, " -o ", o, " -g ", g, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("cTable")) { 
		file.remove (cTable)
		} 
 
		if(exists("oTable")) { 
		file.remove (oTable)
		} 
 
		if(exists("gTable")) { 
		file.remove (gTable)
		} 
