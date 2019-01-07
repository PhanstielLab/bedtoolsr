#' Summarizes a dataset column based upon
#' common column groupings. Akin to the SQL "group by" command.
#' 
#' @param g 
#' @param c 
#' @param o 
#' @param i  Input file. Assumes "stdin" if omitted.
#' 
#' @param full  Print all columns from input file.  The first line in the group is used.
#'  Default: print only grouped columns.
#' 
#' @param inheader Input file has a header line - the first line will be ignored.
#' 
#' @param outheader Print header line in the output, detailing the column names. 
#'  If the input file has headers (-inheader), the output file
#'  will use the input's column names.
#'  If the input file has no headers, the output file
#'  will use "col_1", "col_2", etc. as the column names.
#' 
#' @param header  same as '-inheader -outheader'
#' 
#' @param ignorecase Group values regardless of upper/lower case.
#' 
#' @param prec Sets the decimal precision for output (Default: 5)
#' 
#' @param delim Specify a custom delimiter for the collapse operations.
#' - Example: -delim "|"
#' - Default: ",".
#' 
groupby <- function(g, c, o, i = NULL, full = NULL, inheader = NULL, outheader = NULL, header = NULL, ignorecase = NULL, prec = NULL, delim = NULL)
{ 

			if (!is.character(g) && !is.numeric(g)) {
			gTable = "~/Desktop/gTable.txt"
			write.table(g, gTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			g=gTable } 
			
			if (!is.character(c) && !is.numeric(c)) {
			cTable = "~/Desktop/cTable.txt"
			write.table(c, cTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			c=cTable } 
			
			if (!is.character(o) && !is.numeric(o)) {
			oTable = "~/Desktop/oTable.txt"
			write.table(o, oTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			o=oTable } 
			
		options = "" 
 
			if (!is.null(i)) {
			options = paste(options," -i")
			if(is.character(i) || is.numeric(i)) {
			options = paste(options, " ", i)
			}	
			}
			 
			if (!is.null(full)) {
			options = paste(options," -full")
			if(is.character(full) || is.numeric(full)) {
			options = paste(options, " ", full)
			}	
			}
			 
			if (!is.null(inheader)) {
			options = paste(options," -inheader")
			if(is.character(inheader) || is.numeric(inheader)) {
			options = paste(options, " ", inheader)
			}	
			}
			 
			if (!is.null(outheader)) {
			options = paste(options," -outheader")
			if(is.character(outheader) || is.numeric(outheader)) {
			options = paste(options, " ", outheader)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(ignorecase)) {
			options = paste(options," -ignorecase")
			if(is.character(ignorecase) || is.numeric(ignorecase)) {
			options = paste(options, " ", ignorecase)
			}	
			}
			 
			if (!is.null(prec)) {
			options = paste(options," -prec")
			if(is.character(prec) || is.numeric(prec)) {
			options = paste(options, " ", prec)
			}	
			}
			 
			if (!is.null(delim)) {
			options = paste(options," -delim")
			if(is.character(delim) || is.numeric(delim)) {
			options = paste(options, " ", delim)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools groupby ", options, " -g ", g, " -c ", c, " -o ", o, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("gTable")) { 
		file.remove (gTable)
		} 
 
		if(exists("cTable")) { 
		file.remove (cTable)
		} 
 
		if(exists("oTable")) { 
		file.remove (oTable)
		} 
