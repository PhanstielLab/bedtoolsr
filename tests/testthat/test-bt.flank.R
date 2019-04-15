context("test-flank")

test_that("flank works", {
  A.bed <- read.table(text=
"chr1 100 200
chr1 500 600")
  my.genome <- read.table(text=
"chr1 1000")
  results <- read.table(text=
"chr1  95      100
chr1  200     205
chr1  495     500
chr1  600     605")
  expect_equal(bedtoolsr::bt.flank(A.bed, my.genome, b=5), results)
})
