#' Deletes temp files
#' 
#' @param tempfiles a vector of tempfiles for deletion
#' 
#' ### Define a function that determines establishes files and paths for bedtools functions
deleteTempFiles <- function(tempfiles)
{
  for(tempfile in tempfiles)
    if(exists(tempfile))
      file.remove (tempfile)
}