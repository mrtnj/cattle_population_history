
library(dplyr)
library(readr)



holstein <- read_table("plink/sequence/holstein_chrX.sexcheck")

exclude <- scan("plink/1000bulls_to_exclude.txt", what = "character")

holstein <- filter(holstein, !FID %in% exclude)


holstein$sex <- ""
holstein$sex[holstein$F < 0.2] <- "female"
holstein$sex[holstein$F > 0.4] <- "male"

jersey <- read_table("plink/sequence/jersey_chrX.sexcheck")

jersey$sex <- ""
jersey$sex[jersey$F < 0.2] <- "female"
jersey$sex[jersey$F > 0.4] <- "male"

