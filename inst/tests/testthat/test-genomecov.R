context("test-genomecov")

test_that("genomecov works", {
  A.bed <- read.table(text=
"chr1  10  20
chr1  20  30
chr2  0   500")
  my.genome <- read.table(text=
"chr1  1000
chr2  500")
  results <- read.table(text=
"chr1   0  980  1000  0.98
chr1   1  20   1000  0.02
chr2   1  500  500   1
genome 0  980  1500  0.653333
genome 1  520  1500  0.346667")
  expect_equal(bedtoolsr::genomecov(A.bed, my.genome), results)
})
