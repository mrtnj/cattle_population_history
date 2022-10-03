
## Create breed files for preparing Plink files


library(dplyr)
library(readxl)


metadata <- read_excel("metadata/sample_metadata.xlsx")

metadata$breed_sanitised <- gsub(metadata$breed,
                                 pattern = "ä|å",
                                 replacement = "a")

metadata$breed_sanitised <- tolower(gsub(metadata$breed_sanitised,
                                         pattern = "ö",
                                         replacement = "o"))

## Remove breed with only two samples
metadata <- filter(metadata, breed_sanitised != "ringamalako")


metadata_split <- split(metadata, metadata$breed_sanitised)


dir.create("metadata/breed_files")

for(breed_ix in 1:length(metadata_split))  {
  
  breed <- unique(metadata_split[[breed_ix]]$breed_sanitised)
  
  write.table(metadata_split[[breed_ix]][, c(4, 4)],
              file = paste("metadata/breed_files/", breed, ".txt", sep = ""),
              col.names = FALSE,
              row.names = FALSE,
              quote = FALSE,
              sep = "\t")

}
