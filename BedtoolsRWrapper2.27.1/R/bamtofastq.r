#' Convert BAM alignments to FASTQ files. 
#' 
#' @param i <BAM>
#' @param fq <FQ>
#' @param fq2 FASTQ for second end.  Used if BAM contains paired-end data.
#' BAM should be sorted by query name is creating paired FASTQ.
#' 
#' @param tags Create FASTQ based on the mate info
#' in the BAM R2 and Q2 tags.
#' 
bamtofastq <- function(i, fq, fq2 = NULL, tags = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
			if (!is.character(fq) && !is.numeric(fq)) {
			fqTable = "~/Desktop/fqTable.txt"
			write.table(fq, fqTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			fq=fqTable } 
			
		options = "" 
 
			if (!is.null(fq2)) {
			options = paste(options," -fq2")
			if(is.character(fq2) || is.numeric(fq2)) {
			options = paste(options, " ", fq2)
			}	
			}
			 
			if (!is.null(tags)) {
			options = paste(options," -tags")
			if(is.character(tags) || is.numeric(tags)) {
			options = paste(options, " ", tags)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools271/bin/bedtools bamtofastq ", options, " -i ", i, " -fq ", fq, " > ", tempfile) 
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
 
		if(exists("fqTable")) { 
		file.remove (fqTable)
		} 
