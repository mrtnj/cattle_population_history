
library(dplyr)
library(readr)
library(purrr)

source("R/helper_functions.R")


jackknife <- vector(mode = "list", length = 10)


for (rep in 1:10) {

  jackknife[[rep]] <- read_gone_results(paste0("gone/jackknife_decline/replicate", rep, "/jackknife"),
                                        1:20,
                                        "jackknife_decline")
  
  colnames(jackknife[[rep]])[1] <- "jackknife_fold"
  jackknife[[rep]]$replicate <- rep

}

gone <- bind_rows(jackknife)

write.table(gone,
            file = "outputs/gone_jackknife.txt",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)
