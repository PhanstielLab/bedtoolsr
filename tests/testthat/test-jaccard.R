context("test-jaccard")

test_that("jaccard works", {
  A.bed = data.frame(chrom = c("chr1","chr1"),
                     start = c(10,30),
                     end   = c(20,40))
  
  B.bed = data.frame(chrom = "chr1",
                     start = 15,
                     end   = 20)
  C.bed = data.frame("intersection"=5,
                     "union.intersection"=20,
                     "jaccard" = 0.25,
                     "n_intersections" = 1)
  
  expect_equal(bedtoolsr::jaccard(a = A.bed, b = B.bed), C.bed)
})
