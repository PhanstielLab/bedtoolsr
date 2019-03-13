args <- commandArgs(trailingOnly = TRUE)

print ("Building man files")
library('devtools')
library('roxygen2')
library('testthat')
devtools::document(args[1])

# Test Functions
library("bedtoolsr")
print ("Testing functions")
test_package(package = 'bedtoolsr')
