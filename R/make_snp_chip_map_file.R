

## Create a SNP map file for the SNP chip

library(dplyr)
library(readr)


old_map <- read_tsv("plink/snp_chip/swedish_cattle_snp_chip.map",
                    col_names = FALSE)
colnames(old_map) <- c("chr", "marker_id", "cM", "bp")



lifted <- read_tsv("annotation/cattle150k_ARS-UCD1.2_lifted.bed",
                   col_names = FALSE)

colnames(lifted) <- c("chr", "start", "end", "marker_name", "strand")

lifted$chr <- sub(lifted$chr, pattern = "chr", replacement = "")


## Create position-based marker ids like in the old map and add them in

manifest <- read_csv("annotation/geneseek-ggp-bovine-150k-manifest-file.csv",
                     skip = 7)

manifest$marker_id <- paste(manifest$Chr, manifest$MapInfo, sep = "_")


conversion_table <- manifest[c("marker_id", "Name")]

conversion_table <- filter(conversion_table,
                           !marker_id %in% c("0_0", "Y_0", "NA_NA"))

colnames(conversion_table)[2] <- "marker_name"


lifted_with_ids <- inner_join(lifted, conversion_table)


## Go through the map and add a new position where it exists

new_map <- old_map

for (marker_ix in 1:nrow(new_map)) {
  
  matching_markers <- lifted_with_ids[lifted_with_ids$marker_id ==
                                        new_map$marker_id[marker_ix],]
  
  if (nrow(matching_markers) > 1) {
    print(matching_markers)
    matching_markers <- matching_markers[1,]
  }
    
  if (nrow(matching_markers) == 1) {
    
    new_map$chr[marker_ix] <- matching_markers$chr
    new_map$bp[marker_ix] <- matching_markers$end
    new_map$marker_id[marker_ix] <- matching_markers$marker_name
  } else if (nrow(matching_markers) == 1) {
    new_map$bp[marker_ix] <- 0
  }
}


to_delete <- new_map$marker_id[new_map$bp == 0]


options(scipen = 1e6)

write.table(new_map,
            file = "outputs/snp_chip_map_lifted.map",
            sep = "\t",
            row.names = FALSE,
            col.names = FALSE,
            quote = FALSE)

write(to_delete,
      file = "outputs/snps_to_remove_snp_chip_lifted.txt",
      sep = "\n")
