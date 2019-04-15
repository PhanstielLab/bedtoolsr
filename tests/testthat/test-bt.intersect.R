context("test-intersect")

test_that("intersect works", {
  A.bed <- read.table(text=
"chr1  10  20
chr1  30  40")
  B.bed <- read.table(text=
"chr1  15   20")
  results <- read.table(text=
"chr1  15   20")
  expect_equal(bedtoolsr::bt.intersect(A.bed, B.bed), results)
})
