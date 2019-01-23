#' Extract DNA sequences from a fasta file based on feature coordinates.
#' 
#' @param fi <fasta>
#' @param bed <bed/gff/vcf>
#' @param name Use the name field for the FASTA header
#' 
#' @param fullHeader Use full fasta header.
#' - By default, only the word before the first space or tab 
#' is used.
#' 
#' @param nameplus Use the name field and coordinates for the FASTA header
#' 
#' @param s Force strandedness. If the feature occupies the antisense,
#' strand, the sequence will be reverse complemented.
#' - By default, strand information is ignored.
#' 
#' @param split given BED12 fmt., extract and concatenate the sequences
#' from the BED "blocks" (e.g., exons)
#' 
#' @param tab Write output in TAB delimited format.
#' - Default is FASTA format.
#' 
#' @param fo Output file (opt., default is STDOUT
#' 
getfasta <- function(fi, bed, name = NULL, fullHeader = NULL, nameplus = NULL, s = NULL, split = NULL, tab = NULL, fo = NULL)
{ 

            if (!is.character(fi) && !is.numeric(fi)) {
            fiTable = paste0(tempdir(), "/fiTable.txt")
            write.table(fi, fiTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
            fi=fiTable } 
            
            if (!is.character(bed) && !is.numeric(bed)) {
            bedTable = paste0(tempdir(), "/bedTable.txt")
            write.table(bed, bedTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
            bed=bedTable } 
            
		options = "" 
 
            if (!is.null(name)) {
            options = paste(options," -name")
            if(is.character(name) || is.numeric(name)) {
            options = paste(options, " ", name)
            }   
            }
             
            if (!is.null(fullHeader)) {
            options = paste(options," -fullHeader")
            if(is.character(fullHeader) || is.numeric(fullHeader)) {
            options = paste(options, " ", fullHeader)
            }   
            }
             
            if (!is.null(nameplus)) {
            options = paste(options," -name+")
            if(is.character(nameplus) || is.numeric(nameplus)) {
            options = paste(options, " ", nameplus)
            }   
            }
             
            if (!is.null(s)) {
            options = paste(options," -s")
            if(is.character(s) || is.numeric(s)) {
            options = paste(options, " ", s)
            }   
            }
             
            if (!is.null(split)) {
            options = paste(options," -split")
            if(is.character(split) || is.numeric(split)) {
            options = paste(options, " ", split)
            }   
            }
             
            if (!is.null(tab)) {
            options = paste(options," -tab")
            if(is.character(tab) || is.numeric(tab)) {
            options = paste(options, " ", tab)
            }   
            }
             
            if (!is.null(fo)) {
            options = paste(options," -fo")
            if(is.character(fo) || is.numeric(fo)) {
            options = paste(options, " ", fo)
            }   
            }
            
	# establish output file 
	tempfile = tempfile("bedtoolsr", fileext=".txt")
	bedtools.path <- getOption("bedtools.path")
	if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
	cmd = paste0(bedtools.path, "bedtools getfasta ", options, " -fi ", fi, " -bed ", bed, " > ", tempfile) 
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
