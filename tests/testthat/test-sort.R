context("test-sort")

test_that("sort works", {
  A.bed <- read.table(text=
"chr1 800 1000
chr1 80  180
chr1 1   10
chr1 750 10000")
  results <- read.table(text=
"chr1 750 10000
chr1 800 1000
chr1 80  180
chr1 1   10")
  expect_equal(bedtoolsr::sort(A.bed, sizeD=TRUE), results)
})
