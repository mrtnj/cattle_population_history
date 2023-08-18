
library(AlphaSimR)
library(asrhelper)
library(readr)

args <- commandArgs(trailingOnly = TRUE)

pop_history_file <- args[1]

out_path <- args[2]


pop_history <- read_csv(pop_history_file)

pop_sizes <- generations_ago_to_pop_size(pop_history)


last_ix <- nrow(pop_history)

founders <- simulate_founder_genome(genome_table = cattle_genome_table,
                                    n_ind = pop_sizes[1],
                                    final_Ne = pop_sizes[1],
                                    seg_sites_per_bp = 30,
                                    historical_Ne = NULL,
                                    historical_Ne_time = NULL,
                                    split = NULL,
                                    parallel = TRUE,
                                    n_cores = parallel::detectCores())




simparam <- SimParam$new(founders)

pop <- newPop(founders,
              simparam)




generations <- forward_simulate_population(pop = pop,
                                           pop_sizes = pop_sizes,
                                           simparam = simparam)


geno <- pullSegSiteGeno(generations[[length(generations)]],
                        simParam = simparam)

saveRDS(generations,
        file = paste(out_path, "/generations.Rds", sep = ""))

saveRDS(geno,
        file = paste(out_path, "/geno.Rds", sep = ""))

saveRDS(simparam,
        file = paste(out_path, "/simparam.Rds", sep = ""))
