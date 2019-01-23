#' Mask a fasta file based on feature coordinates.
#' 
#' @param fi <fasta>
#' @param bed <bed/gff/vcf>
#' @param fo <fasta>
#' @param mc  Replace masking character.
#'  Use another character, instead of masking with Ns.
#' 
#' @param fullHeader Use full fasta header.
#'  By default, only the word before the first space or tab
#'  is used.
#' 
#' @param soft  Enforce "soft" masking.
#'  Mask with lower-case bases, instead of masking with Ns.
#' 
maskfasta <- function(fi, bed, fo, mc = NULL, fullHeader = NULL, soft = NULL)
{ 

            if (!is.character(fi) && !is.numeric(fi)) {
            fiTable = paste0(tempdir(), "/fiTable.txt")
            write.table(fi, fiTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
            fi=fiTable } 
            
            if (!is.character(bed) && !is.numeric(bed)) {
            bedTable = paste0(tempdir(), "/bedTable.txt")
            write.table(bed, bedTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
            bed=bedTable } 
            
            if (!is.character(fo) && !is.numeric(fo)) {
            foTable = paste0(tempdir(), "/foTable.txt")
            write.table(fo, foTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
            fo=foTable } 
            
		options = "" 
 
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
             
            if (!is.null(soft)) {
            options = paste(options," -soft")
            if(is.character(soft) || is.numeric(soft)) {
            options = paste(options, " ", soft)
            }   
            }
            
	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools maskfasta ", options, " -fi ", fi, " -bed ", bed, " -fo ", fo, " > ", tempfile) 
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
 
        if(exists("bedTable")) { 
        file.remove (bedTable)
        } 
 
        if(exists("foTable")) { 
        file.remove (foTable)
        } 
