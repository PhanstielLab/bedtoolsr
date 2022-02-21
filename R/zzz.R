.onLoad <- function(libname, pkgname) {
  bedtoolsr_version<-utils::packageVersion("bedtoolsr")
  response<-tryCatch(
  {
    bedtools.path <- getOption("bedtools.path")
    if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
    system(paste0(bedtools.path, "bedtools --version"), intern=TRUE)
  },
  error = function(e)
  {
    warning("bedtools does not appear to be installed or not in your PATH. If it is installed, please add it to your PATH or run:\noptions(bedtools.path = \"/path/to/\")")
    return(NULL)
  })
  if(!is.null(response)) {
    installed_bedtools_version<-substr(response, 11, nchar(response))
    package_bedtools_version<-substr(bedtoolsr_version, 1, nchar(installed_bedtools_version))
    if(installed_bedtools_version != package_bedtools_version) {
      warning(paste("bedtoolsr was built with bedtools version", package_bedtools_version, "but you have version", installed_bedtools_version, "installed. Function syntax may have changed and wrapper will not function correctly. To fix this, please install bedtools version", package_bedtools_version, "and either add it to your PATH or run:\noptions(bedtools.path = \\\"[bedtools path]\\\")"))
    }
  }
}
