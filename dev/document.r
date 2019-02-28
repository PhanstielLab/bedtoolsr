print ("Building man files")
library('devtools')
library('roxygen2')
library('testthat')
setwd('/Users/dphansti/Desktop/bedtoolsr')
devtools::document()

# Test Functions
library("bedtoolsr")
print ("Testing functions")
test_package(package = 'bedtoolsr')
