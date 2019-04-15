context("test-slop")

test_that("slop works", {
  A.bed <- read.table(text=
"chr1 5 100
chr1 800 980")
  my.genome <- read.table(text=
"chr1 1000")
  results <- read.table(text=
"chr1 0 105
chr1 795 985")
  expect_equal(bedtoolsr::bt.slop(A.bed, my.genome, b=5), results)
})
