
library(dplyr)
library(ggplot2)
library(readr)


estimates <- read_tsv("outputs/gone_simulated_cases.txt")

estimates <- filter(estimates, run == "decline")

loco <- read_tsv("outputs/gone_loco.txt")

history_decline <- tibble(generation = c(0, 50, 200),
                          Ne = c(100, 5000, 5000),
                          case = "Decline")


intervals <- summarise(group_by(loco, replicate, Generation),
                          lower = max(Geometric_mean),
                          upper = min(Geometric_mean))



plot_loco <- ggplot() +
  geom_ribbon(aes(x = Generation, ymin = lower, ymax = upper), data = intervals) + 
  geom_line(aes(x = Generation, y = Geometric_mean, group = loco_fold), data = loco) + 
  geom_line(aes(x = Generation, y = Geometric_mean), data = estimates, colour = "red") +
  geom_step(aes(x = generation, y = Ne), colour = "red",
            data = history_decline) +
  facet_wrap(~ replicate) +
  coord_cartesian(xlim = c(0, 100)) +
  coord_cartesian(xlim = c(0, 50), ylim = c(0, 200))


