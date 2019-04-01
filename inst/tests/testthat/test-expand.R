context("test-expand")

test_that("expand works", {
  test.bed <- read.table(text=
"chr1	10	20	1,2,3	10,20,30
chr1	40	50	4,5,6	40,50,60")
  results <- read.table(text=
"chr1	10	20	1,2,3	10
chr1	10	20	1,2,3	20
chr1	10	20	1,2,3	30
chr1	40	50	4,5,6	40
chr1	40	50	4,5,6	50
chr1	40	50	4,5,6	60")
  expect_equal(bedtoolsr::expand(test.bed, c=5), results)
})
