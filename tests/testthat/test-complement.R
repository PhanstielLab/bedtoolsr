context("test-complement")

test_that("complement works", {
  
  A.bed = data.frame(chrom = c("chr1","chr1","chr1"),
             start = c(100,400,500),
             end   = c(200,500,800))
  my.genome = data.frame(chrom = c("chr1","chr2"),
                     size = c(1000,800))
  B.bed = data.frame(V1 = c("chr1","chr1","chr1","chr2"),
                     V2 = c(0,200,800,0),
                     V3   = c(100,400,1000,800))
  
  expect_equal(bedtoolsr::complement(i=A.bed,g=my.genome),B.bed)
})
