
.onLoad <- function(libname, pkgname) {
    installed.packages<-installed.packages()
    row<-which(installed.packages[, 1]=="bedtoolsr")
    if(length(row)>0) {
        bedtoolsr_version<-installed.packages[row, 3]
        hyphens<-gregexpr("-", bedtoolsr_version)
        response<-tryCatch({
            bedtools.path <- getOption("bedtools.path")
            if(!is.null(bedtools.path)) bedtools.path <- paste0(bedtools.path, "/")
            system(paste0(bedtools.path, "bedtools --version"), intern=T)
        }, error = function(e) {
            warning("bedtools does not appear to be installed or not in your PATH. If it is installed, please add it to your PATH or run:
options(bedtools.path = \"[bedtools path]\")")
            return(NULL)
        })
        if(!is.null(response)) {
            installed_bedtools_version<-substr(response, 11, nchar(response))
            package_bedtools_version<-substr(bedtoolsr_version, 1, hyphens[[length(hyphens)]][1]-1)
            if(installed_bedtools_version != package_bedtools_version) {
            warning(paste("bedtoolsr was built with bedtools version", package_bedtools_version, "but you have version", installed_bedtools_version, "installed. Function syntax may have changed and wrapper will not function correctly. To fix this, please install bedtools version", package_bedtools_version, "and either add it to your PATH or run:
options(bedtools.path = \"[bedtools path]\")"))
            }
        }
    }
}
