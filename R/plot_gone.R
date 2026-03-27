
library(dplyr)
library(ggplot2)
library(patchwork)
library(purrr)
library(readr)

source("R/helper_functions.R")

breed_colours <- read_csv("breed_colours.csv")

breeds_seq <- c("rodkulla", "fjall", "holstein", "jersey")

breeds_chip <- c("bohuskulla", "fjallnara", "holstein", "srb", "skb", "fjall",
                 "rodkulla", "vaneko", "ringamala")



gone_seq <- read_gone_results("gone/sequence/", breeds_seq, "seq")
  

gone_chip <- read_gone_results("gone/snp_chip/", breeds_chip, "chip")


gone <- bind_rows(gone_seq, gone_chip)


gone <- inner_join(gone, breed_colours)


plot_all <- qplot(x = Generation, y = Geometric_mean,
                  colour = breed, data = gone, geom = "line") + xlim(0, 200) +
  facet_wrap(~ run)



plot_all + coord_cartesian(ylim = c(0, 50000))

plot_all + coord_cartesian(ylim = c(0, 20000))


jackknife_snp_chip <- read_tsv("outputs/gone_jackknife_snp_chip.txt")

intervals_snp_chip <- summarise(group_by(jackknife_snp_chip, breed, Generation),
                                lower = quantile(Geometric_mean, 0),
                                upper = quantile(Geometric_mean, 1))
intervals_snp_chip$run <- "chip"

intervals_snp_chip <- inner_join(intervals_snp_chip, breed_colours)



jackknife_seq <- read_tsv("outputs/gone_jackknife_1000bulls.txt")

intervals_seq <- summarise(group_by(jackknife_seq, breed, Generation),
                           lower = quantile(Geometric_mean, 0),
                           upper = quantile(Geometric_mean, 1))
intervals_seq$run <- "seq"
intervals_seq$breed <- sub(intervals_seq$breed, pattern = "seq_", replacement = "")

intervals_seq <- inner_join(intervals_seq, breed_colours)


intervals <- rbind(intervals_snp_chip, intervals_seq)

plot_breed <- ggplot() +
  geom_line(aes(x = Generation, y = Geometric_mean),
            data = gone) + xlim(0, 200) +
  geom_ribbon(aes(x = Generation, ymin = lower, ymax = upper,
                  group = paste(breed, run)),
              alpha = 0.1,
              data = intervals) +
  facet_wrap(~ breed_pretty, scale = "free_y") +
  theme_bw() +
  theme(panel.grid = element_blank(),
        strip.background = element_blank()) +
  xlab("Generations ago") +
  ylab("Effective population size")


pdf("figures/supplementary_gone_breeds.pdf",
    width = 10)
print(plot_breed)
dev.off()



gone_chip10 <- filter(gone,
                      ! breed %in% c("fjallnara", "vaneko", "bohuskulla") &
                        run == "chip")


plot_chip_n10 <- qplot(x = Generation, y = Geometric_mean,
                       colour = breed_pretty,
                       data = gone_chip10,
                       geom = "line") +
  scale_colour_manual(
    values = gone_chip10$colour,
    limits = gone_chip10$breed_pretty
    ) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.position = "bottom",
        legend.title = element_blank()) +
  coord_cartesian(xlim = c(0, 50), ylim = c(0, 20000)) +
  ylab("Effective population size") +
  xlab("Generations ago")



pdf("figures/gone_chip.pdf",
    height = 5)
print(plot_chip_n10)
dev.off()


## Holstein comparison

history_macleod <- read_csv("population_histories/macleod2013.csv")
history_macleod <- history_macleod[nrow(history_macleod):1,]
history_macleod$generation <- c(0, cumsum(history_macleod$number_of_generations)[-nrow(history_macleod)])
history_macleod$case <- "Macleod et al. 2013"

history_boitard <- read_csv("population_histories/boitard2016_hol.csv")
history_boitard$case <- "Boitard et al. 2016"

history_boitard_jer <- read_csv("population_histories/boitard2016_jer.csv")
history_boitard_jer$case <- "Boitard et al. 2016"

plot_hol_comparison <- ggplot() +
  geom_line(aes(x = Generation, y = Geometric_mean,
                linetype = breed_pretty,
                group = run),
            data = filter(gone,
                          breed == "holstein" &
                            Generation < 200)) +
  guides(colour = guide_legend(nrow = 2),
         linetype = guide_legend(nrow = 2)) + 
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.position = "bottom",
        legend.title = element_blank()) +
  ylab("Effective population size") +
  xlab("Generations ago") +
  geom_step(aes(x = generation,
                y = Ne,
                colour = case),
            data = bind_rows(history_macleod, history_boitard)) +
  scale_colour_manual(values = c("blue", "red")) +
  coord_cartesian(xlim = c(0, 200),
                  ylim = c(0, 7000)) +
  ggtitle("Holstein")


plot_jer_comparison <- ggplot() +
  geom_line(aes(x = Generation, y = Geometric_mean, colour = breed_pretty),
            data = filter(gone,
                          breed == "jersey" &
                            Generation < 200)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.position = "bottom",
        legend.title = element_blank()) +
  ylab("Effective population size") +
  xlab("Generations ago") +
  geom_step(aes(x = generation,
                y = Ne,
                colour = case),
            data = history_boitard_jer) +
  scale_colour_manual(values = c("blue", "black")) +
  coord_cartesian(xlim = c(0, 200),
                  ylim = c(0, 7000)) +
  ggtitle("Jersey")


plot_hol_jer <- plot_hol_comparison / plot_jer_comparison


pdf("figures/gone_hol_jer.pdf")
print(plot_hol_jer)
dev.off()


## Barplot of final Ne


# plot_final_chip <- ggplot() +
#   geom_bar(aes(x = breed_pretty, y = Geometric_mean, fill = breed_pretty),
#            data = filter(gone_chip_colour, Generation == 1),
#            stat = "identity") +
#   geom_text(aes(x = breed_pretty, y = Geometric_mean + 20,
#                 label = round(Geometric_mean)),
#             data = filter(gone_chip_colour, Generation == 1)) +
#   scale_fill_manual(values = gone_chip_colour$colour[!gone_chip_colour$breed %in% c("fjallnara", "bohuskulla")],
#                     limits = gone_chip_colour$breed_pretty[!gone_chip_colour$breed %in% c("fjallnara", "bohuskulla")]) +
#   theme_bw(base_size = 18) +
#   theme(panel.grid = element_blank(),
#         legend.position = "none") +
#   xlab("") +
#   ylab("Current Ne") +
#   coord_flip()


gone_final <- filter(gone, Generation == 1)
gone_final$breed_pretty <- factor(
  gone_final$breed_pretty,
  levels = gone_final$breed_pretty[order(gone_final$Geometric_mean,
                                         decreasing = TRUE)]
)

largeN <- c("holstein", "jersey", "fjall", "srb")

gone_final$N_indicator <- ""
gone_final$N_indicator[gone_final$breed %in% largeN] <- "*"


plot_final <- ggplot() +
  geom_bar(aes(x = breed_pretty,
               y = Geometric_mean, fill = breed_pretty),
           data = gone_final,
           stat = "identity") +
  geom_text(aes(x = breed_pretty, y = Geometric_mean + 20,
                label = paste0(round(Geometric_mean), N_indicator)),
            data = gone_final) +
  scale_fill_manual(values = gone$colour,
                    limits = gone$breed_pretty) +
  theme_bw(base_size = 18) +
  theme(panel.grid = element_blank(),
        legend.position = "none") +
  xlab("") +
  ylab("Current Ne") +
  coord_flip()


pdf("figures/gone_holstein_comparison.pdf",
    height = 5)
print(plot_hol_comparison)
dev.off()

pdf("figures/gone_final_ne.pdf",
    height = 5, width = 10)
print(plot_final)
dev.off()




## Generation of greatest change

find_greatest_decline <- function(hist) {
  change <- hist[1:(length(hist) - 1)] - hist[2:length(hist)]
  which.min(change) 
}

decline_summaries <- summarise(group_by(gone, breed_pretty, run),
                               decline = find_greatest_decline(Geometric_mean),
                               mean_before = mean(Geometric_mean[Generation %in% 50:200]),
                               last = Geometric_mean[1])

write.csv(decline_summaries[, c(1, 3, 4)],
          file = "tables/decline_summaries.csv",
          quote = FALSE,
          row.names = FALSE)


## Supplementary data of all histories

supp_data <- filter(gone, Generation <= 200)[, c("breed_pretty", "Generation", "Geometric_mean")]
colnames(supp_data) <- c("Breed", "Generation", "Ne")


dir.create("tables")

write.csv(supp_data,
          file = "tables/supplementary_data_histories.csv",
          quote = FALSE,
          row.names = FALSE)




