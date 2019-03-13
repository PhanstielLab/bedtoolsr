context("test-merge")

test_that("merge works", {
  A.bed <- read.table(text=
"chr1  100  200
chr1  180  250
chr1  250  500
chr1  501  1000")
  results <- read.table(text=
"chr1  100  500
chr1  501  1000")
  expect_equal(bedtoolsr::merge(A.bed), results)
})
