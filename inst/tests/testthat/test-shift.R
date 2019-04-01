context("test-shift")

test_that("shift works", {
  A.bed <- read.table(text=
"chr1 5 100 +
chr1 800 980 -")
  my.genome <- read.table(text=
"chr1 1000")
  results <- read.table(text=
"chr1 10 105 +
chr1 805 985 -")
  expect_equal(bedtoolsr::shift(A.bed, my.genome, s=5), results)
})
