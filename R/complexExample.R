## Download and unzip loop calls bedpe file from Phanstiel et. al, 2017
download.file(url = "https://www.cell.com/cms/10.1016/j.molcel.2017.08.006/attachment/0a5229f1-46bb-4aae-aa42-33651377e633/mmc3.zip",
              destfile =  "Loops_PMA.txt.zip")
unzip(zipfile = "Loops_PMA.txt.zip", files = "molcel_6338_Table_S2_Loops_PMA.txt")


## Download CTCF Peak bed file from Van Bortle et. al, 2017
download.file(url = "https://www.ncbi.nlm.nih.gov/geo/download/?acc=GSE96800&format=file&file=GSE96800%5FCTCF%5Fpeak%5FedgeR%5Fraw%2Etxt%2Egz",
              destfile = "CTCF_peaks.txt.gz")


## Read in bed and bedpe files (optional but helfpul for subsequent R operations)
loopsBedpe  <- read.table(file = "molcel_6338_Table_S2_Loops_PMA.txt", header = T)
ctcfPeaks   <- read.table(file = gzfile("CTCF_peaks.txt.gz"), header = T)

## Add 5kb up/downstream from each ctcf peak with the bedtoolsr slop function
ctcfPeaks   <- bedtoolsr::bt.slop(i = ctcfPeaks, g = "data/hg19", b = 5000, header = T)

## Compute overlaps with bedtoolsr (find loops that have CTCF bound at both, one, or no ends?)
bothEnds    <- bedtoolsr::bt.pairtobed(a = loopsBedpe, b = ctcfPeaks, type = "both")
oneEnd      <- bedtoolsr::bt.pairtobed(a = loopsBedpe, b = ctcfPeaks, type = "xor")
neitherEnd  <- bedtoolsr::bt.pairtobed(a = loopsBedpe, b = ctcfPeaks, type = "neither")

## Count the number of loops found in each case
totalN      <- nrow(unique(loopsBedpe))
bothN       <- nrow(unique(bothEnds[,1:10]))
oneN        <- nrow(unique(oneEnd[,1:10]))
neitherN    <- nrow(unique(neitherEnd[,1:10]))

## Calculate percentages of the total number of loops and round
bothP       <- round(bothN/totalN*100)
oneP        <- round(oneN/totalN*100)
neitherP    <- round(neitherN/totalN*100)


## Create data frame to plot results
df  <- data.frame(
        group = c("Both", "One", "Neither"),
        number = c(bothN, oneN, neitherN),
        percent = c(bothP, oneP, neitherP)
    )

## Plot results
library(ggplot2)
ggplot(data = df, aes(x = 1, y = percent, fill = group))+
  geom_col(col = "white")+
  coord_polar("y") + 
  scale_fill_manual(values = c("#2171b5", "#bdd7e7", "#6baed6"))+
  labs(title = "Loop anchors with bound CTCF")+
  annotate(geom = "text",
           x = c(1.0, 1.25, 1.75),
           y = c(60, 8, 17.25),
           label = paste0(df$group, " (", df$percent, "%)"),
           col = c("white", "white", "black"),
           size = 4.5)+
  theme_void()+
  theme(
    plot.title = element_text(hjust = 0.5, vjust = -15, face = "bold"),
    legend.position = "none", text = element_text(face = "bold")
  )
  

