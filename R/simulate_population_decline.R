
library(AlphaSimR)
library(asrhelper)


args <- commandArgs(trailingOnly = TRUE)

out_path <- args[1]



founders <- simulate_founder_genome(genome_table = cattle_genome_table,
                                    n_ind = 10000,
                                    final_Ne = 10000,
                                    seg_sites_per_bp = 30,
                                    historical_Ne = NULL,
                                    historical_Ne_time = NULL,
                                    split = NULL)


simparam <- SimParam$new(founders)

pop <- newPop(founders,
              simparam)


n_gen_before <- 150
N_after <- 200
n_gen_after <- 50

pop_sizes <- c(rep(10000, n_gen_before),
               rep(N_after, n_gen_after))


generations <- forward_simulate_population(pop = pop,
                                           pop_sizes = pop_sizes,
                                           simparam = simparam)


geno <- pullSegSiteGeno(generations[[length(generations)]],
                        simParam = simparam)

saveRDS(generations,
        file = paste(out_path, "/generations.Rds", sep = ""))

saveRDS(generations,
        file = paste(out_path, "/geno.Rds", sep = ""))

