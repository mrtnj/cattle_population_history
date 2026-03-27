
library(dplyr)
library(readr)
library(purrr)

source("R/helper_functions.R")


breeds <- c("seq_holstein", "seq_jersey")

jackknife <- vector(mode = "list", length = length(breeds))
names(jackknife) <- breeds


for (breed_ix in 1:length(breeds)) {
  
  files <- system(paste0("ls gone/jackknife_", breeds[breed_ix], "/*/Output_Ne_data"), intern = TRUE)
  
  n_jack <- length(files)

  jackknife[[breed_ix]] <- read_gone_results(dirname(files),
                                             "",
                                             paste0("jackknife_", breeds[breed_ix]))
  
  colnames(jackknife[[breed_ix]])[1] <- "jackknife_fold"
  jackknife[[breed_ix]]$breed <- breeds[breed_ix]

}

gone <- bind_rows(jackknife)

gone <- filter(gone, jackknife_fold <= 40)

write.table(gone,
            file = "outputs/gone_jackknife_1000bulls.txt",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)
