context("test-makewindows")

test_that("makewindows works", {
  input.bed <- read.table(text=
"chr5 60000 70000")
  results <- read.table(text=
"chr5 60000 61000
chr5 61000 62000
chr5 62000 63000
chr5 63000 64000
chr5 64000 65000
chr5 65000 66000
chr5 66000 67000
chr5 67000 68000
chr5 68000 69000
chr5 69000 70000")
  expect_equal(bedtoolsr::bt.makewindows(b=input.bed, n=10), results)
})
