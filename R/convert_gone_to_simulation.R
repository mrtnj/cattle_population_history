

## Convert GONE run data to population histories for simulations

library(dplyr)
library(purrr)
library(readr)
library(tibble)

source("R/helper_functions.R")


gone_seq <- read_gone_results("gone/sequence/", "fjall", "seq")

gone_chip <- read_gone_results("gone/snp_chip/", c("fjall", "holstein"), "chip")


gone <- rbind(gone_seq, gone_chip)


gone_chopped <- filter(gone, Generation <= 200)

gone_chopped$Ne <- round(gone_chopped$Geometric_mean)



gone_split <- split(gone_chopped, list(gone_chopped$breed, gone_chopped$run))


for (dataset_ix in 1:length(gone_split)) {
  if (nrow(gone_split[[dataset_ix]]) > 0) {
    results <- tibble(generations_ago = gone_split[[dataset_ix]]$Generation,
                      Ne = gone_split[[dataset_ix]]$Ne)
    filename <- paste("population_histories/gone_",
                      unique(gone_split[[dataset_ix]]$breed),
                      "_",
                      unique(gone_split[[dataset_ix]]$run),
                      ".csv",
                      sep = "")
    
    write.csv(results,
              file = filename,
              quote = FALSE,
              row.names = FALSE)
    
  }
}
