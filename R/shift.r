#' Shift each feature by requested number of base pairs.
#' 
#' @param i <bed/gff/vcf>
#' @param g <genome>
#' @param p Shift features on the + strand by -p base pairs.
#' - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param s Shift the BED/GFF/VCF entry -s base pairs.
#' - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param m Shift features on the - strand by -m base pairs.
#' - (Integer) or (Float, e.g. 0.1) if used with -pct.
#' 
#' @param pct Define -s, -m and -p as a fraction of the feature's length.
#' E.g. if used on a 1000bp feature, -s 0.50, 
#' will shift the feature 500 bp "upstream".  Default = false.
#' 
#' @param header Print the header from the input file prior to results.
#' 
shift <- function(i, g, p = NULL, s = NULL, m = NULL, pct = NULL, header = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
			if (!is.character(g) && !is.numeric(g)) {
			gTable = "~/Desktop/gTable.txt"
			write.table(g, gTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			g=gTable } 
			
		options = "" 
 
			if (!is.null(p)) {
			options = paste(options," -p")
			if(is.character(p) || is.numeric(p)) {
			options = paste(options, " ", p)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			 
			if (!is.null(m)) {
			options = paste(options," -m")
			if(is.character(m) || is.numeric(m)) {
			options = paste(options, " ", m)
			}	
			}
			 
			if (!is.null(pct)) {
			options = paste(options," -pct")
			if(is.character(pct) || is.numeric(pct)) {
			options = paste(options, " ", pct)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste0(getOption("bedtools.path", default="."), "/bedtools shift ", options, " -i ", i, " -g ", g, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("iTable")) { 
		file.remove (iTable)
		} 
 
		if(exists("gTable")) { 
		file.remove (gTable)
		} 
