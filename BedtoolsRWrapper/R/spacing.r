#' Report (last col.) the gap lengths between intervals in a file.
#' 
#' @param i <bed/gff/vcf/bam>
spacing <- function(i)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
		options = "" 

	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("/Users/mayurapatwardhan/Downloads/bedtools2/bin/bedtools spacing ", options, " -i ", i, " > ", tempfile) 
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
