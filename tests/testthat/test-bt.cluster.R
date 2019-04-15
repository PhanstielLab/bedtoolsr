context("test-cluster")

test_that("cluster works", {
  A.bed <- read.table(text=
"chr1  100  200
chr1  180  250
chr1  250  500
chr1  501  1000")
  results <- read.table(text=
"chr1  100     200     1
chr1  180     250     1
chr1  250     500     1
chr1  501     1000    2")
  expect_equal(bedtoolsr::bt.cluster(A.bed), results)
})
