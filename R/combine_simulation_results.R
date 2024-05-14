
library(dplyr)
library(readr)
library(purrr)

source("R/helper_functions.R")

n_rep <- 10

gone_macleod <- read_gone_results("gone/simulations_macleod/replicate",
                                  1:10,
                                  "macleod")

gone_decline <- read_gone_results("gone/simulations_decline/replicate",
                                  1:10,
                                  "decline")

gone_recovery <- read_gone_results("gone/simulations_recovery/replicate",
                                   1:10,
                                   "recovery")


gone <- bind_rows(gone_macleod, gone_decline, gone_recovery)
colnames(gone)[1] <- "replicate"

write.table(gone,
            file = "outputs/gone_simulated_cases.txt",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)


macleod_files <- paste("snep/simulations_macleod/replicate",
                       1:n_rep,
                       ".NeAll", sep = "")

snep_macleod <- map_dfr(macleod_files,
                        read_tsv,
                        .id = "replicate")
snep_macleod$case <- "macleod"


decline_files <- paste("snep/simulations_decline/replicate",
                       1:n_rep,
                       ".NeAll", sep = "")

snep_decline <- map_dfr(decline_files,
                        read_tsv,
                        .id = "replicate")
snep_decline$case <- "decline"


recovery_files <- paste("snep/simulations_recovery/replicate",
                       1:n_rep,
                       ".NeAll", sep = "")

snep_recovery <- map_dfr(recovery_files,
                        read_tsv,
                        .id = "replicate")
snep_recovery$case <- "recovery"


snep <- bind_rows(snep_macleod, snep_decline, snep_recovery)


write.table(snep,
            file = "outputs/snep_simulated_cases.txt",
            sep = "\t",
            quote = FALSE,
            row.names = FALSE)