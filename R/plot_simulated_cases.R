library(ggplot2)
library(readr)


gone <- read_tsv("outputs/gone_simulated_cases.txt")

snep <- read_tsv("outputs/snep_simulated_cases.txt")




plot_gone <- qplot(x = Generation,
                   y = Geometric_mean,
                   group = paste(replicate, run),
                   colour = run,
                   data = gone,
                   xlim = c(0, 200),
                   geom = "line")


plot_snep <- qplot(x = GenAgo,
                   y = Ne,
                   group = paste(replicate, case),
                   colour = case,
                   data = snep,
                   #xlim = c(0, 200),
                   geom = "line")
