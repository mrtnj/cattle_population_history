
library(dplyr)
library(readr)
library(purrr)

source("R/helper_functions.R")


breeds <- c("srb", "skb", "rodkulla", "bohuskulla",
            "fjall", "fjallnara", "vaneko", "ringamala", "holstein")

jackknife <- vector(mode = "list", length = length(breeds))
names(jackknife) <- breeds


for (breed_ix in 1:length(breeds)) {
  
  n_jack <- length(system(paste0("ls gone/jackknife_", breeds[breed_ix]), intern = TRUE))

  jackknife[[breed_ix]] <- read_gone_results(paste0("gone/jackknife_", breeds[breed_ix],
                                                    "/jackknife"),
                                             1:n_jack,
                                             paste0("jackknife_", breeds[breed_ix]))
  
  colnames(jackknife[[breed_ix]])[1] <- "jackknife_fold"
  jackknife[[breed_ix]]$breed <- breeds[breed_ix]

}

gone <- bind_rows(jackknife)

write.table(gone,
            file = "outputs/gone_jackknife_snp_chip.txt",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)
