context("test-coverage")

test_that("coverage works", {
  A.bed <- read.table(text=
"chr1  0   100
chr1  100 200
chr2  0   100")
  B.bed <- read.table(text=
"chr1  10  20
chr1  20  30
chr1  30  40
chr1  100 200")
  results <- read.table(text=
"chr1  0   100  3  30  100 0.3000000
chr1  100 200  1  100 100 1.0000000
chr2  0   100  0  0   100 0.0000000")
  expect_equal(bedtoolsr::coverage(A.bed, B.bed), results)
})
