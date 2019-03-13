context("test-map")

test_that("map works", {
  a.bed <- read.table(text=
"chr1        10      20      a1      1       +
chr1        50      60      a2      2       -
chr1        80      90      a3      3       -")
  b.bed <- read.table(text=
"chr1        12      14      b1      2       +
chr1        13      15      b2      5       -
chr1        16      18      b3      5       +
chr1        82      85      b4      2       -
chr1        85      87      b5      3       +")
  results <- read.table(text=
"chr1        10      20      a1      1       +       12
chr1        50      60      a2      2       -       .
chr1        80      90      a3      3       -       5")
  expect_equal(bedtoolsr::map(a.bed, b.bed), results)
})
