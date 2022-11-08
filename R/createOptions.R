#' Creates options based on user input
#'
#' @param names vector of names of options
#' @param values vector of values of options
#'
#' ### Define a function that determines establishes files and paths for bedtools functions
createOptions <- function(names, values)
{
  options <- ""
  if(length(names) > 0)
    for(i in 1:length(names))
      if(!is.null(values[[i]])&&(!is.logical(values[[i]])||values[[i]]))
      {
        options <- paste(options, paste(" -", names[i], sep=""))
        if(is.character(values[[i]]) || is.numeric(values[[i]]))
          options <- paste(options, " ", values[i])
        else if(is.list(values[[i]]))
          options <- paste(options, " ", values[i][[1]])
      }

  # return the two items
  return(options)
}
