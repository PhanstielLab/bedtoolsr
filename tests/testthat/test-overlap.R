context("test-overlap")

test_that("overlap works", {
  input <- read.table(text=
"chr1  10  20  A  chr1  15  25  B
chr1  10  20  C  chr1  25  35  D")
  results <- read.table(text=
"chr1  10  20  A  chr1  15  25  B  5
chr1  10  20  C  chr1  25  35  D  -5")
  expect_equal(bedtoolsr::overlap(input, cols="2,3,6,7"), results)
})
