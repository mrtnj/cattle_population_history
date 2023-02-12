
## Take a map file of physical positions and a linkage map 
## and interpolate the cM positions of the map file

library(dplyr)
library(readr)

source("R/linkage_map_functions.R")



## Plink file of biallelic SNPs

linkage_map <- read_tsv("annotation/ma2015_ARS-UCD1.2.txt")

map <- read_tsv("plink/swedish_cattle_biallelic_snps.map",
                col_names = FALSE)

colnames(map) <- c("chr", "id", "cM", "bp")


## Give variants IDs to allow easy removing with Plink

map$id <- paste(map$chr, "_", map$bp, sep = "")

linkage_map$chr <- sub(linkage_map$chr, pattern = "chr", replacement = "")


## Interpolate

map_cM <- interpolate_genome(map,
                             linkage_map)

## Identify variants to be removed outside the linkage map

to_remove_ends <- map_cM$id[is.na(map_cM$cM)]

map_cM$cM[is.na(map_cM$cM)] <- 0


## Identify variants to be removed because they overlap with other
## variants on the same genetic position

n_snps <- nrow(map_cM)
previous_cM <- 0
tol <- 1e-8

is_duplicated <- logical(n_snps)

for (snp_ix in 1:n_snps) {
  
  current_cM <- map_cM$cM[snp_ix]
  
  if (previous_cM > current_cM - tol &
      previous_cM < current_cM + tol) {
    ## If current marker is in same position as previous
    is_duplicated[snp_ix] <- TRUE
  }
  
  previous_cM <- current_cM
}


to_remove <- unique(c(to_remove_ends,
                      map_cM$id[is_duplicated]))


## Write out map and variant IDs to be removed

dir.create("outputs")

options(scipen = 1e6)

write(to_remove,
      file = "outputs/snps_to_remove.txt",
      sep = "\n")

write.table(map_cM,
            file = "outputs/snp_map_cM.map",
            quote = FALSE,
            row.names = FALSE,
            col.names = FALSE,
            sep = "\t")



