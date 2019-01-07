#' Take sample of input file(s) using reservoir sampling algorithm.
#' 
#' @param i <bed/gff/vcf/bam>
#' @param ubam Write uncompressed BAM output. Default writes compressed BAM.
#' 
#' @param bed If using BAM input, write output as BED.
#' 
#' @param n The number of records to generate.
#' - Default = 1,000,000.
#' - (INTEGER)
#' 
#' @param header Print the header from the A file prior to results.
#' 
#' @param s Require same strandedness.  That is, only give records
#' that have the same strand. Use '-s forward' or '-s reverse'
#' for forward or reverse strand records, respectively.
#' - By default, records are reported without respect to strand.
#' 
#' @param seed Supply an integer seed for the shuffling.
#' - By default, the seed is chosen automatically.
#' - (INTEGER)
#' 
#' @param nobuf Disable buffered output. Using this option will cause each line
#' of output to be printed as it is generated, rather than saved
#' in a buffer. This will make printing large output files 
#' noticeably slower, but can be useful in conjunction with
#' other software tools and scripts that need to process one
#' line of bedtools output at a time.
#' 
#' @param iobuf Specify amount of memory to use for input buffer.
#' Takes an integer argument. Optional suffixes K/M/G supported.
#' Note: currently has no effect with compressed files.
#' 
sample <- function(i, ubam = NULL, bed = NULL, n = NULL, header = NULL, s = NULL, seed = NULL, nobuf = NULL, iobuf = NULL)
{ 

			if (!is.character(i) && !is.numeric(i)) {
			iTable = "~/Desktop/iTable.txt"
			write.table(i, iTable, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
			i=iTable } 
			
		options = "" 
 
			if (!is.null(ubam)) {
			options = paste(options," -ubam")
			if(is.character(ubam) || is.numeric(ubam)) {
			options = paste(options, " ", ubam)
			}	
			}
			 
			if (!is.null(bed)) {
			options = paste(options," -bed")
			if(is.character(bed) || is.numeric(bed)) {
			options = paste(options, " ", bed)
			}	
			}
			 
			if (!is.null(n)) {
			options = paste(options," -n")
			if(is.character(n) || is.numeric(n)) {
			options = paste(options, " ", n)
			}	
			}
			 
			if (!is.null(header)) {
			options = paste(options," -header")
			if(is.character(header) || is.numeric(header)) {
			options = paste(options, " ", header)
			}	
			}
			 
			if (!is.null(s)) {
			options = paste(options," -s")
			if(is.character(s) || is.numeric(s)) {
			options = paste(options, " ", s)
			}	
			}
			 
			if (!is.null(seed)) {
			options = paste(options," -seed")
			if(is.character(seed) || is.numeric(seed)) {
			options = paste(options, " ", seed)
			}	
			}
			 
			if (!is.null(nobuf)) {
			options = paste(options," -nobuf")
			if(is.character(nobuf) || is.numeric(nobuf)) {
			options = paste(options, " ", nobuf)
			}	
			}
			 
			if (!is.null(iobuf)) {
			options = paste(options," -iobuf")
			if(is.character(iobuf) || is.numeric(iobuf)) {
			options = paste(options, " ", iobuf)
			}	
			}
			
	# establish output file 
	tempfile = "~/Desktop/tempfile.txt" 
	cmd = paste("bedtools sample ", options, " -i ", i, " > ", tempfile) 
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
