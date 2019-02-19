context("test-closest")

test_that("closest works", {
  A.bed = data.frame(chrom="chr1",
                     start=30000,
                     end=30010)
  B.bed = data.frame(chrom=c("chr1","chr1"),
                     start=c(10000,20000),
                     end=c(10010,20010))
  C.bed = data.frame(V1="chr1",
                     V2=30000,
                     V3=30010,
                     V4="chr1",
                     V5=20000,
                     V6=20010)
  
  expect_equal(bedtoolsr::closest(A.bed,B.bed),C.bed)
})
