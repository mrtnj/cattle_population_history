library(dplyr)
library(ggplot2)
library(patchwork)
library(readr)
library(tibble)


gone <- read_tsv("outputs/gone_simulated_cases.txt")

snep <- read_tsv("outputs/snep_simulated_cases.txt")


gone$generation <- gone$Generation
gone$Ne <- gone$Geometric_mean
gone$case <- gone$run
gone$case[gone$run == "macleod"] <- "Macleod et al. (2013)"
gone$case[gone$run == "recovery"] <- "Recovery"
gone$case[gone$run == "decline"] <- "Decline"

  
history_macleod <- read_csv("population_histories/macleod2013.csv")
history_macleod <- history_macleod[nrow(history_macleod):1,]
history_macleod$generation <- c(0, cumsum(history_macleod$number_of_generations)[-nrow(history_macleod)])
history_macleod$case <- "Macleod et al. (2013)"

history_decline <- tibble(generation = c(0, 50, 200),
                          Ne = c(100, 5000, 5000),
                          case = "Decline")

history_recovery <- tibble(generation = c(0, 20, 50, 200),
                           Ne = c(100, 50, 5000, 5000),
                           case = "Recovery")


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
        strip.background = element_blank(),
        legend.position = "none") +
  scale_colour_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) +
  xlab("Generation")




snep$generation <- snep$GenAgo
snep$case[snep$case == "macleod"] <- "Macleod et al. (2013)"
snep$case[snep$case == "recovery"] <- "Recovery"
snep$case[snep$case == "decline"] <- "Decline"

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
        strip.background = element_blank(),
        legend.position = "none") +
  scale_colour_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) +
  xlab("Generation")



pdf("figures/simulated_gone.pdf",
    height = 3.5)
print(plot_gone)
dev.off()

pdf("figures/simulated_snep.pdf",
    height = 3.5)
print(plot_snep)
dev.off()




## Mean absolute difference

history_to_vector <- function(history) {
  max_gen <- max(history$generation)
  flat_history <- numeric(max_gen)
  gen <- 1

  for (change_ix in 2:nrow(history)) {
    flat_history[gen:history$generation[change_ix]] <- history$Ne[change_ix - 1]
    gen <- history$generation[change_ix] + 1
  }
  flat_history
}

history_decline_vector <- history_to_vector(history_decline)
history_recovery_vector <- history_to_vector(history_recovery)
history_macleod_vector <- history_to_vector(history_macleod)[1:200]



gone_summary_decline <- summarise(group_by(filter(gone, run == "decline" & Generation <= 200),
                                           Generation, run),
                                  mean = mean(Ne),
                                  sd = sd(Ne),
                                  range = abs(max(Ne) - min(Ne)),
                                  mad = mean(abs(Ne - history_decline_vector[Generation])))


gone_summary_macleod <- summarise(group_by(filter(gone, run == "macleod" & Generation <= 200),
                                           Generation, run),
                                  mean = mean(Ne),
                                  sd = sd(Ne),
                                  range = abs(max(Ne) - min(Ne)),
                                  mad = mean(abs(Ne - history_macleod_vector[Generation])))


gone_summary_recovery <- summarise(group_by(filter(gone, run == "recovery" & Generation <= 200),
                                            Generation, run),
                                   mean = mean(Ne),
                                   sd = sd(Ne),
                                   range = abs(max(Ne) - min(Ne)),
                                   mad = mean(abs(Ne - history_recovery_vector[Generation])))



gone_summary <- bind_rows(gone_summary_decline, gone_summary_recovery, gone_summary_macleod)

gone_summary$case <- gone_summary$run
gone_summary$case[gone_summary$run == "macleod"] <- "Macleod et al. (2013)"
gone_summary$case[gone_summary$run == "recovery"] <- "Recovery"
gone_summary$case[gone_summary$run == "decline"] <- "Decline"


plot_mad <- ggplot() +
  geom_point(aes(x = Generation,
                 y = mad,
                 colour = case),
             size = 0.1,
             data = gone_summary) +
  facet_wrap( ~ case) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        strip.background = element_blank(),
        legend.position = "none") +
  scale_colour_manual(values = c("#66c2a5", "#fc8d62", "#8da0cb")) +
  xlab("Generation") +
  ylab("Mean absolute error")



plot_combined_gone <- plot_gone / plot_mad


pdf("figures/simulated_gone_mad.pdf")
print(plot_combined_gone)
dev.off()