context("test-subtract")

test_that("subtract works", {
  A.bed <- read.table(text=
"chr1  10   20
chr1  100  200")
  B.bed <- read.table(text=
"chr1  0    30
chr1  180  300")
  results <- read.table(text=
"chr1  100  180")
  expect_equal(bedtoolsr::bt.subtract(A.bed, B.bed), results)
})
