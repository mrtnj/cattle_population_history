library(ggplot2)
library(readr)
library(tibble)


gone <- read_tsv("outputs/gone_simulated_cases.txt")

snep <- read_tsv("outputs/snep_simulated_cases.txt")


gone$generation <- gone$Generation
gone$Ne <- gone$Geometric_mean
gone$case <- gone$run

  
history_macleod <- read_csv("population_histories/macleod2013.csv")
history_macleod <- history_macleod[nrow(history_macleod):1,]
history_macleod$generation <- c(0, cumsum(history_macleod$number_of_generations)[-nrow(history_macleod)])
history_macleod$case <- "macleod"

history_decline <- tibble(generation = c(0, 50, 200),
                          Ne = c(100, 5000, 5000),
                          case = "decline")

history_recovery <- tibble(generation = c(0, 20, 50, 200),
                           Ne = c(100, 50, 5000, 5000),
                           case = "recovery")


plot_gone <- ggplot() +
  geom_line(aes(x = generation,
                y = Ne,
                group = paste(replicate, case),
                colour = case),
            data = gone) +
  geom_step(aes(x = generation, y = Ne),
            data = bind_rows(history_macleod, history_decline, history_recovery)) +
  facet_wrap(~ case) +
  coord_cartesian(xlim = c(0, 200), ylim = c(0, 7000)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        strip.background = element_blank())



snep$generation <- snep$GenAgo

plot_snep <- ggplot() +
  geom_line(aes(x = generation,
                y = Ne,
                group = paste(replicate, case),
                colour = case),
            data = snep) +
  geom_step(aes(x = generation, y = Ne),
            data = bind_rows(history_macleod, history_decline, history_recovery)) +
  facet_wrap(~ case) +
  coord_cartesian(xlim = c(0, 200), ylim = c(0, 7000)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        strip.background = element_blank())



pdf("figures/simulated_gone.pdf",
    height = 3.5)
print(plot_gone)
dev.off()

pdf("figures/simulated_snep.pdf",
    height = 3.5)
print(plot_snep)
dev.off()