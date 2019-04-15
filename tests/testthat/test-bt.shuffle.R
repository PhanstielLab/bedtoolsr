context("test-shuffle")

test_that("shuffle works", {
  A.bed <- read.table(text=
"chr1  0  100  a1  1  +
chr1  0  1000 a2  2  -")
  my.genome <- read.table(text=
"chr1  10000
chr2  8000
chr3  5000
chr4  2000")
  results <- read.table(text=
"chr1	9632	9732	a1	1	+
chr4	994	1994	a2	2	-")
  expect_equal(bedtoolsr::bt.shuffle(A.bed, my.genome, seed=100), results)
})
