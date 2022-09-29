
## Take a map file of physical positions and a linkage map 
## and interpolate the cM positions of the map file

library(dplyr)
library(readr)



## Linear interpolation of genetic marker position

interpolate_cM <- function(marker_pos,
                           bp_before,
                           bp_after,
                           cM_before,
                           cM_after) {
  
  delta_bp <- bp_after - bp_before
  delta_cM <- cM_after - cM_before
  
  cM_per_bp <- delta_cM/delta_bp
  
  cM_before +  cM_per_bp * (marker_pos - bp_before)
}


interpolate_chromosome <- function(map_chr, linkage_map_chr) {
  n_variants <- nrow(map_chr)
  
  cM <- numeric(n_variants)
  
  for (variant_ix in 1:n_variants) {
    
    marker_pos <- map_chr$bp[variant_ix]
    
    ix_before <- max(which(linkage_map_chr$position_bp < marker_pos))
    ix_after <- min(which(linkage_map_chr$position_bp > marker_pos))
    
    
    if (ix_after == 1) {
      cM_position <- NA
      # cM_position <- interpolate_cM(marker_pos,
      #                               bp_before = 0,
      #                               bp_after = linkage_map_chr$position_bp[ix_after],
      #                               cM_before = 0,
      #                               cM_after = linkage_map_chr$position_cM[ix_after])
    } else {
      ## Most cases
      cM_position <- interpolate_cM(marker_pos,
                                    bp_before = linkage_map_chr$position_bp[ix_before],
                                    bp_after = linkage_map_chr$position_bp[ix_after],
                                    cM_before = linkage_map_chr$position_cM[ix_before],
                                    cM_after = linkage_map_chr$position_cM[ix_after])
    }
    
    cM[variant_ix] <- cM_position
    
  }
  cM 
}


linkage_map <- read_tsv("annotation/ma2015_ARS-UCD1.2.txt")


map <- read_tsv("plink/srb.map",
                col_names = FALSE)

colnames(map) <- c("chr", "id", "cM", "bp")


## Give variants IDs to allow easy removing with Plink

map$id <- paste(map$chr, "_", map$bp, sep = "")



linkage_map$chr <- sub(linkage_map$chr, pattern = "chr", replacement = "")

map_split <- split(map, map$chr)



## Interpolate each chromosome

n_chr <- length(map_split)

for (chr_ix in 1:n_chr) {
  
  chr <- unique(map_split[[chr_ix]]$chr)
  
  linkage_map_chr <- linkage_map[linkage_map$chr == chr,]
  
  map_split[[chr_ix]]$cM <- interpolate_chromosome(map_split[[chr_ix]],
                                                   linkage_map_chr)
  
}




map_cM <- bind_rows(map_split)

## Identify variants to be removed outside the linkage map

to_remove <- map_cM$id[is.na(map_cM$cM)]

map_cM$cM[is.na(map_cM$cM)] <- 0


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

