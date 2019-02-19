context("test-intersect")

test_that("Basic Intersection Works", {
  A.bed = data.frame(chrom=c("chr1","chr1"),
                     start=c(10,30),
                     end=c(20,40))
  B.bed = data.frame(chrom="chr1",
                     start=15,
                     end=20)
  C.bed = data.frame(V1="chr1",
                     V2=15,
                     V3=20)
  expect_equal(bedtoolsr::intersect(A.bed,B.bed),C.bed)
})
