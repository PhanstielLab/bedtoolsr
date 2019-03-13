context("test-window")

test_that("window works", {
  A.bed <- read.table(text=
"chr1  100  200")
  B.bed <- read.table(text=
"chr1  500  1000
chr1  1300 2000")
  results <- read.table(text=
"chr1  100  200  chr1  500  1000")
  expect_equal(bedtoolsr::window(A.bed, B.bed), results)
})
