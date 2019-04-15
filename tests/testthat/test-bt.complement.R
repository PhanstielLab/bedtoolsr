context("test-complement")

test_that("complement works", {
  A.bed <- read.table(text=
"chr1  100  200
chr1  400  500
chr1  500  800")
  my.genome <- read.table(text=
"chr1  1000
chr2  800")
  results <- read.table(text=
"chr1  0   100
chr1  200 400
chr1  800 1000
chr2  0   800")
  expect_equal(bedtoolsr::bt.complement(A.bed, my.genome), results)
})
