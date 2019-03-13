#' Determines if arguments are paths or R objects. Makes temp files when
#' neccesary. Makes a list of files to use in bedtools call. Makes a list
#' of temp files to delete at end of function 
#' 
#' @param input the input for an argument.  Could be a path to a file, an R object (data frame), or a list of any combination thereof
#' @param name the name of the argument
#' @param allowRobjects boolean whether or not to allow R objects as inputs
#' 
#' ### Define a function that determines establishes files and paths for bedtools functions
establishPaths <- function(input,name="",allowRobjects=TRUE)
{
  # convert to list if neccesary
  if (!inherits(input, "list")  )
  {
    input = list(input)
  }
  
  # iterate through list making files where neccesary and recording tmp files for deletion
  i = 0
  inputpaths = c()
  inputtmps  = c()
  for (item in input)
  {
    i = i + 1
    filepath = item
    # if it is an R object
    if (!is.character(item) && !is.numeric(item)) {
      
      if (allowRobjects == FALSE)
      {
        stop("R objects are not permitted as arguments for",name)
      }
      
      # write a temp file
      filepath = paste0(tempdir(), "/" ,name,"_",i,".txt")
      write.table(item, filepath, append = "FALSE", sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE) 
      
      # record temp file for deletion
      inputtmps = c(inputtmps,filepath)
    }
    
    # record file path for use
    inputpaths = c(inputpaths,filepath)
  }
  
  # join them by spaces
  finalargument = paste(inputpaths,collapse=" ")
  
  # return the two items
  return (list(finalargument,inputtmps))
}
