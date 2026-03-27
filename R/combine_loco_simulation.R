
library(dplyr)
library(readr)
library(purrr)

source("R/helper_functions.R")


loco <- vector(mode = "list", length = 10)


for (rep in 1:10) {

  loco[[rep]] <- read_gone_results(paste0("gone/loco_decline/replicate", rep, "/loco"),
                                        1:29,
                                        "loco_decline")
  
  colnames(loco[[rep]])[1] <- "loco_fold"
  loco[[rep]]$replicate <- rep

}

gone <- bind_rows(loco)

write.table(gone,
            file = "outputs/gone_loco.txt",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)
