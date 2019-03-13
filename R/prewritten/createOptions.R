#' Creates options based on user input
#' 
#' @param names vector of names of options
#' @param values vector of values of options
#' 
#' ### Define a function that determines establishes files and paths for bedtools functions
createOptions <- function(names,values)
{
  
  options = "" 
  if (length(names) > 0)
  {
    for (i in 1:length(names))
    {
      if (!is.null(values[[i]])) {
        options = paste(options,paste(" -",names[i],sep=""))
        if(is.character(values[[i]]) || is.numeric(values[[i]])) {
          options = paste(options, " ", values[i])
        }   
      }
    }
  }
  
  # return the two items
  return (options)
}
