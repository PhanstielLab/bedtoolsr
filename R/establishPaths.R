#' Determines if arguments are paths or R objects. Makes temp files when
#' neccesary. Makes a list of files to use in bedtools call. Makes a list
#' of temp files to delete at end of function.
#'
#' @param input the input for an argument.  Could be a path to a file, an R object (data frame), or a list of any combination thereof
#' @param name the name of the argument
#' @param allowRobjects boolean whether or not to allow R objects as inputs
#'
#' ### Define a function that determines establishes files and paths for bedtools functions
establishPaths <- function(input, name="", allowRobjects=TRUE)
{
  oo <- options(scipen = 999)
  on.exit(options(oo))

  if(is.null(input))
    return(NULL)

  bedtools.path <- getOption("bedtools.path")

  # convert to list if necessary
  if(!inherits(input, "list"))
    input <- list(input)

  # iterate through list making files where necessary and recording tmp files for deletion
  inputpaths <- c()
  inputtmps <- c()
  for(item in input)
  {
    filepath <- item
    # if it is an R object
    if(!is.character(item) && !is.numeric(item))
    {
      if(allowRobjects == FALSE)
        stop("R objects are not permitted as arguments for",name)

      # write a temp file
      filepath <- tempfile(name, fileext=".txt")
      if(!is.null(bedtools.path) && grepl("wsl", bedtools.path, ignore.case=TRUE))
        filepath <- system(paste0("wsl wslpath -a -u \"", filepath, "\""), intern=TRUE)
      utils::write.table(item, filepath, append = FALSE, sep = "	", quote = FALSE, col.names = FALSE, row.names = FALSE)

      # record temp file for deletion
      inputtmps <- c(inputtmps, filepath)
    }
    else if(!file.exists(item) && file.exists(system.file("data", item, package = "bedtoolsr")))
    {
      filepath <- system.file("data", item, package = "bedtoolsr")
    }

    # record file path for use
    if(!is.null(bedtools.path) && grepl("wsl", bedtools.path, ignore.case=TRUE))
      filepath <- system(paste0("wsl wslpath -a -u \"", filepath, "\""), intern=TRUE)
    inputpaths <- c(inputpaths, filepath)
  }

  # join them by spaces
  finalargument <- paste(inputpaths, collapse=" ")

  # return the two items
  return(list(finalargument, inputtmps))
}
