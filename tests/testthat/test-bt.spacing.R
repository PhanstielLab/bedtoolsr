context("test-spacing")

test_that("spacing works", {
  test.bed <- read.table(text=
"chr1    0   10 
chr1    10  20 
chr1    19  30 
chr1    35  45 
chr1    100 200")
  results <- read.table(text=
"chr1    0   10  . 
chr1    10  20  0 
chr1    19  30  -1 
chr1    35  45  5 
chr1    100 200 55")
  expect_equal(bedtoolsr::bt.spacing(test.bed), results)
})
