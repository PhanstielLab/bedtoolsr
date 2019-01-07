
.onLoad <- function(libname, pkgname) {
  response<-system("bedtools --version", intern=T)
  if(!exists("response")) {
    stop("bedtools does not appear to be installed. ")
  }
  installed_bedtools_version<-substr(response, 11, nchar(response))
  if(length(which(installed.packages()[, 1]=="bedtoolsr"))>0) {
    bedtoolsr_version<-installed.packages()[which(installed.packages()[, 1]=="bedtoolsr"), 3]
    hyphens<-gregexpr("-", bedtoolsr_version)
    package_bedtools_version<-substr(bedtoolsr_version, 1, hyphens[[length(hyphens)]][1]-1)
    if(installed_bedtools_version != package_bedtools_version) {
      warning(paste("bedtoolsr was built with bedtools version", package_bedtools_version, "but you have version", installed_bedtools_version, "installed. Function syntax may have changed and wrapper will not function correctly. To fix this, please install bedtools version", package_bedtools_version, "and either add it to your PATH or run:
  ", "options(bedtools.path = \"[bedtools path]\")"))
    }
  }
}
