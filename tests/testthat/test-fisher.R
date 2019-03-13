context("test-fisher")

test_that("fisher works", {
  a.bed <- read.table(text=
"chr1  10  20
chr1  30  40
chr1  51      52")
  b.bed <- read.table(text=
"chr1  15   25
chr1  51      52")
  write("chr1\t500", "t.genome")
  results <- read.table(header=TRUE, text=
"left    right   two-tail    ratio
1   0.0053476   0.0053476   inf")
  expect_equal(bedtoolsr::fisher(a.bed, b.bed, "t.genome"), results)
  file.remove("t.genome")
})
