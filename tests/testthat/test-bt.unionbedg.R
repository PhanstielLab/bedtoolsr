context("test-unionbedg")

test_that("unionbedg works", {
  one.bg <- read.table(text=
"chr1 1000 1500 10
chr1 2000 2100 20")
  two.bg <- read.table(text=
"chr1 900 1600 60
chr1 1700 2050 50")
  three.bg <- read.table(text=
"chr1 1980 2070 80
chr1 2090 2100 20")
  results <- read.table(text=
"chr1 900  1000 0  60 0
chr1 1000 1500 10 60 0
chr1 1500 1600 0  60 0
chr1 1700 1980 0  50 0
chr1 1980 2000 0  50 80
chr1 2000 2050 20 50 80
chr1 2050 2070 20 0  80
chr1 2070 2090 20 0  0
chr1 2090 2100 20 0  20")
  expect_equal(bedtoolsr::bt.unionbedg(list(one.bg, two.bg, three.bg)), results)
})
