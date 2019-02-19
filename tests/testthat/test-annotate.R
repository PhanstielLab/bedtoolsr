context("test-annotate")

test_that("annotate works", {
  
  variants.bed = data.frame(c("chr1","chr2","chr3"),
                            V1 = c(100,500,1000), 
                            V2 = c(200,1000,5000), 
                            V3 = c("nasty","ugly","big"),
                            V4 = c(1,2,3), 
                            V5 = c("-","+","-"))
  
  genes.bed = data.frame(c("chr1","chr1","chr3"),
                         V1 = c(150,175,0), 
                         V2 = c(200,250,10000), 
                         V3 = c("geneA","geneB","geneC"),
                         V4 = c(1,2,3), 
                         V5 = c("+","+","-"))
  
  conserve.bed = data.frame(c("chr1","chr2","chr3"),
                         V1 = c(0,700,400), 
                         V2 = c(10000,10000,10000), 
                         V3 = c("cons1","cons2","cons3"),
                         V4 = c(1,2,3), 
                         V5 = c("+","-","+"))  
   
  known_var.bed = data.frame(c("chr1","chr1","chr2"),
                            V1 = c(0,150,0), 
                            V2 = c(120,160,10000), 
                            V3 = c("known1","known2","known3"),
                            V5 = c("-","-","+"))   

  results.bed = data.frame(V1 = c("chr1","chr2","chr3"),
                                      V2 = c(100,500,1000), 
                                      V3 = c(200,100,5000), 
                                      V4 = c("nasty","ugly","big"),
                                      V5 = c(1,2,3), 
                                      V6 = c("-","+","-"),
                                      V7 = c(0.500000,0.000000,1.000000),
                                      V8 = c(1.000000,0.600000,0.250000),
                                      V9 = c(0.300000,1.000000,0.000000))

  expect_equal(bedtoolsr::annotate (i=variants.bed, files= list(genes.bed,conserve.bed,known_var.bed)), 4)
})
