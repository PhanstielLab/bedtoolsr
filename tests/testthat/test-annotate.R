context("test-annotate")

test_that("annotate works", {
  variants.bed <- read.table(text=
"chr1 100  200   nasty 1  -
chr2 500  1000  ugly  2  +
chr3 1000 5000  big   3  -")
  genes.bed <- read.table(text=
"chr1 150  200   geneA 1  +
chr1 175  250   geneB 2  +
chr3 0    10000 geneC 3  -")
  conserve.bed <- read.table(text=
"chr1 0    10000 cons1 1  +
chr2 700  10000 cons2 2  -
chr3 4000 10000 cons3 3  +")  
  known_var.bed <- read.table(text=
"chr1 0    120   known1   -
chr1 150  160   known2   -
chr2 0    10000 known3   +")
  results <- read.table(text=
"chr1  100     200     nasty   1       -       0.500000        1.000000        0.300000
chr2  500     1000    ugly    2       +       0.000000        0.600000        1.000000
chr3  1000    5000    big     3       -       1.000000        0.250000        0.000000")
  expect_equal(bedtoolsr::annotate(variants.bed, list(genes.bed, conserve.bed, known_var.bed)), results)
})
