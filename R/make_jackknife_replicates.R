
## Take a pair of plink text files and create leave-one-out replicates

library(readr)


args <- commandArgs(trailingOnly=TRUE)

in_file_prefix <- args[1] ## "simulations/decline/replicate1/genotypes100k"
out_dir <- args[2] ## "plink/jackknife_decline/"


ped <- read_table(paste0(in_file_prefix, ".ped"), col_names = FALSE,
                  col_types = cols(.default = "character"))

map <- read_table(paste0(in_file_prefix, ".map"), col_names = FALSE,
                  col_types = cols(.default = "character"))


dir.create(out_dir)


options(scipen = 1e6)

folds <- 1:nrow(ped)

if (length(folds) > 50) {
  folds <- sample(folds, 50)
  folds <- sort(folds)
}

for (n in folds) {

  repl <- ped[-n, ]
  
  write.table(repl,
              file = paste0(out_dir, "/jackknife", n, ".ped"),
              sep = " ",
              row.names = FALSE,
              col.names = FALSE,
              quote = FALSE)
  
  write.table(map,
              file = paste0(out_dir, "/jackknife", n, ".map"),
              sep = " ",
              row.names = FALSE,
              col.names = FALSE,
              quote = FALSE)
}
