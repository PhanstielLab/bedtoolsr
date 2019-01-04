#' Mask a fasta file based on feature coordinates.
#' 
#' @param fi <fasta>
#' @param fo <fasta>
#' @param bed <bed/gff/vcf>
#' @param soft  Enforce "soft" masking.
#'  Mask with lower-case bases, instead of masking with Ns.
#' 
#' @param mc  Replace masking character.
#'  Use another character, instead of masking with Ns.
#' 
#' @param fullHeader Use full fasta header.
#'  By default, only the word before the first space or tab
#'  is used.
#' 
maskfasta <- function(fi, fo, bed, soft = NULL, mc = NULL, fullHeader = NULL)
{ 

			if (!is.character(fi) && !is.numeric(fi)) {
			fiTable = "~/Desktop/fiTable.txt"
			write.table(fi, fiTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			fi=fiTable } 
			
			if (!is.character(fo) && !is.numeric(fo)) {
			foTable = "~/Desktop/foTable.txt"
			write.table(fo, foTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			fo=foTable } 
			
			if (!is.character(bed) && !is.numeric(bed)) {
			bedTable = "~/Desktop/bedTable.txt"
			write.table(bed, bedTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			bed=bedTable } 
			
		options = "" 
 
			if (!is.null(soft)) {
			options = paste(options," -soft")
			if(is.character(soft) || is.numeric(soft)) {
			options = paste(options, " ", soft)
			}	
			}
			 
			if (!is.null(mc)) {
			options = paste(options," -mc")
			if(is.character(mc) || is.numeric(mc)) {
			options = paste(options, " ", mc)
			}	
			}
			 
			if (!is.null(fullHeader)) {
			options = paste(options," -fullHeader")
			if(is.character(fullHeader) || is.numeric(fullHeader)) {
			options = paste(options, " ", fullHeader)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools maskfasta ", options, " -fi ", fi, " -fo ", fo, " -bed ", bed, " > ", tempfile) 
	system(cmd) 
	results = read.table(tempfile,header=FALSE,sep="\t") 
		if (file.exists(tempfile)){ 
		file.remove(tempfile) 
		}
		return (results)
		}
		 
		if(exists("fiTable")) { 
		file.remove (fiTable)
		} 
 
		if(exists("foTable")) { 
		file.remove (foTable)
		} 
 
		if(exists("bedTable")) { 
		file.remove (bedTable)
		} 
