
## Create breed files for preparing Plink files


library(dplyr)
library(readr)
library(tibble)


fam <- read_tsv("snp_chip_data/MergedSwedishCattleB.fam",
                  col_names = FALSE)


breed_names <- tibble(code = c("BHP", "SMC", "SPC", "FNC", "RMC", "SRP", "SHF", "SRC", "VAC"),
                      breed = c("bohuskulla", "fjall", "skb", "fjallnara", "ringamala", "rodkulla", "holstein", "srb", "vaneko"))


metadata <- inner_join(fam, breed_names, by = c("X1" = "code"))


metadata_split <- split(metadata, metadata$breed)


dir.create("metadata/snp_chip_breed_files/")

for(breed_ix in 1:length(metadata_split))  {
  
  breed <- unique(metadata_split[[breed_ix]]$breed)
  
  write.table(metadata_split[[breed_ix]][, c("X1", "X2")],
              file = paste("metadata/snp_chip_breed_files/", breed, ".txt", sep = ""),
              col.names = FALSE,
              row.names = FALSE,
              quote = FALSE,
              sep = "\t")
  
}
