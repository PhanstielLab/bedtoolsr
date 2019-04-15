context("test-closest")

test_that("closest works", {
  A.bed <- read.table(text=
"chr1  10  20  a1  1 -")
  B.bed <- read.table(text=
"chr1  7   8   b1  1 -
chr1  15  25  b2  2 +")
  results <- read.table(text=
"chr1  10  20  a1  1 - chr1  15  25  b2  2 +")
  expect_equal(bedtoolsr::bt.closest(A.bed, B.bed), results)
})
