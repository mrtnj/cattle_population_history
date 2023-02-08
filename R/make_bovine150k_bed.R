
## Prepare positions from SNP manifest for lifting

library(readr)
library(tibble)


manifest <- read_csv("annotation/geneseek-ggp-bovine-150k-manifest-file.csv",
                     skip = 7)



bed <- tibble(chr = manifest$Chr,
              start = manifest$MapInfo - 1,
              end = manifest$MapInfo,
              name = manifest$Name)

bed <- filter(bed, chr != "0")

bed$chr <- paste("chr", bed$chr, sep = "")

options(scipen = 1e6)

write.table(bed, 
            file = "annotation/cattle150k_UMD3_positions.bed",
            row.names = FALSE,
            col.names = FALSE,
            quote = FALSE,
            sep = "\t")
