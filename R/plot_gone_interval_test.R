
library(dplyr)
library(ggplot2)
library(patchwork)
library(purrr)
library(tidyr)
library(readr)


estimates <- read_tsv("outputs/gone_simulated_cases.txt")

estimates <- filter(estimates, run == "decline")

## Leave one sample out

jackknife <- read_tsv("outputs/gone_jackknife.txt")

history_decline <- tibble(generation = c(0, 50, 200),
                          Ne = c(100, 5000, 5000),
                          case = "Decline")


intervals_jackknife <- summarise(group_by(jackknife, replicate, Generation),
                                 lower = quantile(Geometric_mean, 0),
                                 upper = quantile(Geometric_mean, 1))


plot_jackknife <- ggplot() +
  geom_ribbon(aes(x = Generation, ymin = lower, ymax = upper), data = intervals_jackknife,
              fill = "grey") + 
  ##geom_line(aes(x = Generation, y = Geometric_mean, group = jackknife_fold), data = jackknife) + 
  geom_line(aes(x = Generation, y = Geometric_mean), data = estimates, colour = "black") +
  geom_step(aes(x = generation, y = Ne), colour = "blue",
            data = history_decline) +
  facet_wrap(~ replicate) +
  coord_cartesian(xlim = c(0, 100)) +
  theme_classic() +
  theme(strip.background = element_blank()) +
  ylab("Effective population size") +
  ggtitle("Leave one sample out")


## Leave one chromosome out

loco <- read_tsv("outputs/gone_loco.txt")


intervals_loco <- summarise(group_by(loco, replicate, Generation),
                       upper = max(Geometric_mean),
                       lower = min(Geometric_mean))



plot_loco <- ggplot() +
  geom_ribbon(aes(x = Generation, ymin = lower, ymax = upper), data = intervals_loco,
              fill = "grey") + 
  ##geom_line(aes(x = Generation, y = Geometric_mean, group = loco_fold), data = loco) + 
  geom_line(aes(x = Generation, y = Geometric_mean), data = estimates, colour = "black") +
  geom_step(aes(x = generation, y = Ne), colour = "blue",
            data = history_decline) +
  facet_wrap(~ replicate) +
  coord_cartesian(xlim = c(0, 100)) +
  theme_classic() +
  theme(strip.background = element_blank()) +
  ylab("Effective population size") +
  ggtitle("Leave one chromosome out")


## Check coverage

truth <- numeric(max(history_decline$generation))
last_ne <- history_decline$Ne[1]
truth[1] <- last_ne
for(gen in 2:length(truth)) {
  if (any(history_decline$generation == gen)) {
    last_ne <- history_decline$Ne[history_decline$generation == gen]
  }
  truth[gen] <- last_ne
}

check_coverage <- function(truth, interval) {
  len <- length(truth)
  truth >= interval$lower[1:len] & truth <= interval$upper[1:len]
}


intervals_jackknife_split <- split(intervals_jackknife, intervals_jackknife$replicate)

coverage_jackknife <- map_dfc(intervals_jackknife_split, check_coverage, truth = truth)


plot(rowSums(coverage_jackknife)/10, ylim = c(0, 1), type = "l")


intervals_loco_split <- split(intervals_loco, intervals_loco$replicate)

coverage_loco <- map_dfc(intervals_loco_split, check_coverage, truth = truth)

lines(rowSums(coverage_loco)/10, col = "red")

coverage_summaries <- data.frame(generation = 1:200,
                                 coverage_jackknife = rowSums(coverage_jackknife)/10,
                                 coverage_loco = rowSums(coverage_loco)/10)


coverage_summaries_long <- pivot_longer(coverage_summaries, -generation)


plot_coverage_summary <- qplot(x = generation, y = value,
                               colour = ifelse(name == "coverage_jackknife",
                                               "Leave one sample out",
                                               "Leave one chromosome out"),
                               data = coverage_summaries_long, geom = "line") +
  theme_classic() +
  scale_colour_manual(values = c("black", "grey")) +
  theme(legend.position = "bottom",
        legend.title = element_blank()) +
  xlab("Generation") +
  ylab("Coverage of true value") +
  ylim(c(0, 1))


plot_combined <- plot_jackknife / plot_loco / plot_coverage_summary



pdf("figures/supplementary_interval_test.pdf",
    width = 10, height = 12)
print(plot_combined)
dev.off()
