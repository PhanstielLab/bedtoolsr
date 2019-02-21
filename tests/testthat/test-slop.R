context("test-slop")

test_that("multiplication works", {
  A.bed = data.frame(chrom="chr1",
                     start=15,
                     end=20)
  genome = data.frame(chrom=c("chr1","chr2"),size=c(1000,5000))
  B.bed = data.frame(V1="chr1",
                     V2=10,
                     V3=25)
  expect_equal(bedtoolsr::slop(i=A.bed,b=5,g=genome), B.bed)
})
