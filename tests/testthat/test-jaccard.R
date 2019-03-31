context("test-jaccard")

test_that("jaccard works", {
  A.bed <- read.table(text=
"chr1  10  20
chr1  30  40")
  B.bed <- read.table(text=
"chr1  15   20")
  results <- read.table(header=TRUE, text=
"intersection  union   jaccard n_intersections
5     20      0.25    1")
  expect_equal(bedtoolsr::jaccard(A.bed, B.bed), results)
})
