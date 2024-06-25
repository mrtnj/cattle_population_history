
library(dplyr)
library(ggplot2)
library(patchwork)
library(purrr)
library(readr)


colours <- read_csv("breed_colours.csv")


read_freq <- function(filename, label) {
  
  freq <- read_table(filename)
  freq$label <- label
  
  freq
}

get_bin_proportion <- function(freq, bin_width) {
  
  bin_starts <- seq(from = 0, to = 0.5 - bin_width, by = bin_width)
  n_bins <- length(bin_starts)
  bin_counts <- numeric(n_bins)
  
  for (bin_ix in 1:n_bins) {
    in_bin <- freq[freq$MAF >= bin_starts[bin_ix] & 
                     freq$MAF < bin_starts[bin_ix] + bin_width,]
    bin_counts[bin_ix] <- nrow(in_bin)  
  }
  
  tibble(bin_start = bin_starts, 
         proportion = bin_counts / sum(bin_counts))
}


freq_files_chip <- paste("model_checks/", c("fjall", "rodkulla", "holstein", "srb"),
                         "_chip.frq", sep = "")

freq_labels_chip <- tibble(case = as.character(1:length(freq_files_chip)),
                           label = c("Fjäll", "Rödkulla",
                                     "Swedish Holstein-Friesian", "Swedish Red"))

freq_chip <- pmap(list(filename = freq_files_chip,
                       label = freq_labels_chip$label),
                  read_freq)


binned_maf_chip <- map_dfr(freq_chip,
                           get_bin_proportion,
                           bin_width = 0.1,
                           .id = "case")

binned_maf_chip_labels <- inner_join(binned_maf_chip, freq_labels_chip)


freq_files_chip_sim <- paste(rep(
  paste("model_checks/gone_", c("fjall", "rodkulla", "holstein", "srb"),
        "_chip_replicate",
        sep = ""),
  each = 10),
  1:10,
  ".frq", sep = ""
)

freq_labels_sim <- tibble(case = as.character(1:length(freq_files_chip_sim)),
                          label = rep(c("Fjäll", "Red Polled",
                                        "Swedish Holstein-Friesian", "Swedish Red"),
                                      each = 10))

freq_chip_simulated <- pmap(
  list(filename = freq_files_chip_sim,
       label = freq_labels_sim$label),
  read_freq
)




binned_maf_sim <- map_dfr(freq_chip_simulated,
                          get_bin_proportion,
                          bin_width = 0.1,
                          .id = "case")

binned_maf_sim_label <- inner_join(binned_maf_sim, freq_labels_sim)




freq_files_swe_seq <- paste("model_checks/", c("fjall", "rodkulla"),
                         "_seq.frq", sep = "")

freq_labels_swe_seq <- tibble(case = as.character(1:length(freq_files_swe_seq)),
                              label = c("Fjäll", "Red Polled"))

freq_swe_seq <- pmap(list(filename = freq_files_swe_seq,
                          label = freq_labels_swe_seq$label),
                     read_freq)

binned_maf_swe_seq <- map_dfr(freq_swe_seq,
                              get_bin_proportion,
                              bin_width = 0.1,
                              .id = "case")

binned_maf_swe_seq_label <- inner_join(binned_maf_swe_seq, freq_labels_swe_seq)


colours_freq_chip <- filter(colours, 
                            breed_pretty %in% binned_maf_sim_label$label)

bin_labels0.1 <- paste("[", seq(from = 0, to = 0.4, by = 0.1), ", ",
                       seq(from = 0.1, to = 0.5, by = 0.1), "]", sep = "")

plot_freq_chip <- ggplot() +
  geom_line(aes(x = bin_start,
                y = proportion,
                colour = label,
                group = case),
            data = binned_maf_sim_label) +
  geom_line(aes(x = bin_start,
                y = proportion,
                colour = label),
            linetype = 2,
            data = binned_maf_chip_labels) +
  geom_line(aes(x = bin_start,
                y = proportion,
                colour = label),
            linetype = 3,
            linewidth = 1,
            data = binned_maf_swe_seq_label) +
  scale_colour_manual(values = colours_freq_chip$colour,
                      limits = colours_freq_chip$breed_pretty) +
  scale_x_continuous(labels = bin_labels0.1) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.title = element_blank()) +
  xlab("Minor allele frequency window") +
  ylab("Proportion variants") +
  ylim(0, 0.5)



## HOL, JER


freq_files_seq <- paste("model_checks/", c("holstein", "jersey"),
                         "_seq.frq", sep = "")

freq_labels_seq <- tibble(case = as.character(1:length(freq_files_seq)),
                          label = c("Holstein 1000 Bulls", "Jersey 1000 Bulls"))

freq_seq <- pmap(list(filename = freq_files_seq,
                      label = freq_labels_seq$label),
                 read_freq)


binned_maf_seq <- map_dfr(freq_seq,
                          get_bin_proportion,
                          bin_width = 0.05,
                          .id = "case")

binned_maf_seq_labels <- inner_join(binned_maf_seq, freq_labels_seq)


freq_files_seq_sim <- paste(rep(
  paste("model_checks/gone_", c("holstein", "jersey"),
        "_seq_replicate",
        sep = ""),
  each = 10),
  1:10,
  ".frq", sep = ""
)

freq_labels_seq_sim <- tibble(case = as.character(1:length(freq_files_seq_sim)),
                              label = rep(c("Holstein 1000 Bulls", "Jersey 1000 Bulls"),
                                          each = 10))

freq_seq_simulated <- pmap(
  list(filename = freq_files_seq_sim,
       label = freq_labels_seq_sim$label),
  read_freq
)

binned_maf_seq_sim <- map_dfr(freq_seq_simulated,
                              get_bin_proportion,
                              bin_width = 0.05,
                              .id = "case")

binned_maf_seq_sim_labels <- inner_join(binned_maf_seq_sim, freq_labels_seq_sim)





freq_files_macleod <- paste(rep(
  paste("model_checks/macleod_replicate",
        sep = ""),
  each = 10),
  1:10,
  ".frq", sep = ""
)

freq_labels_macleod <- tibble(case = as.character(1:10),
                              label = "Macleod et al. (2013)")

freq_macleod <- pmap(
  list(filename = freq_files_macleod,
       label = freq_labels_macleod$label),
  read_freq
)

binned_maf_macleod <- map_dfr(freq_macleod,
                              get_bin_proportion,
                              bin_width = 0.05,
                              .id = "case")

binned_maf_macleod_labels <- inner_join(binned_maf_macleod, freq_labels_macleod)



colours_freq_seq <- filter(colours, 
                           breed_pretty %in% binned_maf_seq_sim_labels$label)


bin_labels0.05 <- paste("[", seq(from = 0, to = 0.45, by = 0.05), ", ",
                        seq(from = 0.05, to = 0.5, by = 0.05), "]", sep = "")


plot_freq_seq <- ggplot() +
  geom_line(aes(x = bin_start,
                y = proportion,
                colour = label,
                group = case),
            data = binned_maf_seq_sim_labels) +
  geom_line(aes(x = bin_start,
                y = proportion,
                colour = label,
                group = case),
            linetype = 2,
            data = binned_maf_seq_labels) +
  geom_line(aes(x = bin_start,
                y = proportion,
                colour = label,
                group = case),
            linetype = 3,
            linewidth = 1,
            data = binned_maf_macleod_labels) +
  scale_colour_manual(values = colours_freq_seq$colour,
                      limits = colours_freq_seq$breed_pretty) +
  scale_x_continuous(labels = bin_labels0.05,
                     breaks = seq(from = 0, to = 0.45, by = 0.05),
                     guide = guide_axis(n.dodge = 2)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.title = element_blank()) +
  xlab("Minor allele frequency window") +
  ylab("Proportion variants") +
  ylim(0, 0.5)



## F_het


het_files_chip <- paste("model_checks/", c("fjall", "rodkulla", "holstein", "srb"),
                        "_chip.het", sep = "")

het_labels_chip <- tibble(case = as.character(1:length(het_files_chip)),
                          label = c("Fjäll", "Rödkulla", "Swedish Holstein-Friesian", "Swedish Red"))

het_chip <- pmap_dfr(list(filename = het_files_chip,
                          label = het_labels_chip$label),
                     read_freq)

het_chip_summarised <- 
  summarise(group_by(het_chip, label), meanF = mean(F), sdF = sd(F))


het_files_sim_chip <- paste(rep(
  paste("model_checks/gone_", c("fjall", "rodkulla", "holstein", "srb"),
        "_chip_replicate",
        sep = ""),
  each = 10),
  1:10,
  ".het", sep = ""
)

het_labels_sim <- tibble(case = as.character(1:length(het_files_sim_chip)),
                         label = rep(c("Fjäll", "Rödkulla",
                                       "Swedish Holstein-Friesian", "Swedish Red"),
                                     each = 10))

het_chip_simulated <- pmap(
  list(filename = het_files_sim_chip,
       label = het_labels_sim$label),
  read_freq
)

het_chip_sim_summarised <-
  map_dfr(het_chip_simulated,
          function(het) summarise(group_by(het, label), meanF = mean(F), sdF = sd(F)))


het_files_swe_seq <- paste("model_checks/", c("fjall", "rodkulla"),
                           "_seq.het", sep = "")

het_labels_swe_seq <- tibble(case = as.character(1:length(het_files_swe_seq)),
                             label = c("Fjäll", "Rödkulla"))

het_swe_seq <- pmap_dfr(list(filename = het_files_swe_seq,
                             label = het_labels_swe_seq$label),
                        read_freq)

het_swe_seq_summarised <- 
  summarise(group_by(het_swe_seq, label), meanF = mean(F), sdF = sd(F))



plot_het_chip <- ggplot() +
  geom_violin(aes(x = label,
                  y = F),
              data = het_chip) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  colour = "grey",
                  size = 0.25,
                  position = position_jitter(),
                  data = het_chip_sim_summarised) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  data = het_chip_summarised) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  colour = "red",
                  position = position_nudge(x = 0.05),
                  data = het_swe_seq_summarised) +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  geom_hline(yintercept = 0, linetype = 2) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.title = element_blank()) +
  ylab("Homozygosity inbreeding coefficient") +
  xlab("Population") +
  ylim(-0.35, 1)



## HOL, JER

het_files_seq <- paste("model_checks/", c("holstein", "jersey"),
                        "_seq.het", sep = "")

het_labels_seq <- tibble(case = as.character(1:length(het_files_seq)),
                          label = c("Holstein", "Jersey"))

het_seq <- pmap_dfr(list(filename = het_files_seq,
                         label = het_labels_seq$label),
                    read_freq)

het_seq_summarised <- 
  summarise(group_by(het_seq, label), meanF = mean(F), sdF = sd(F))


het_files_sim_seq <- paste(rep(
  paste("model_checks/gone_", c("holstein", "jersey"),
        "_seq_replicate",
        sep = ""),
  each = 10),
  1:10,
  ".het", sep = ""
)

het_labels_sim_seq <- tibble(case = as.character(1:length(het_files_sim_seq)),
                             label = rep(c("Holstein", "Jersey"),
                                         each = 10))

het_seq_simulated <- pmap(
  list(filename = het_files_sim_seq,
       label = het_labels_sim_seq$label),
  read_freq
)

het_seq_sim_summarised <-
  map_dfr(het_seq_simulated,
          function(het) summarise(group_by(het, label), meanF = mean(F), sdF = sd(F)))


het_files_macleod <- paste(rep(
  paste("model_checks/macleod_replicate",
        sep = ""),
  each = 10),
  1:10,
  ".het", sep = ""
)


het_macleod <- pmap(
  list(filename = het_files_macleod,
       label = freq_labels_macleod$label),
  read_freq
)


het_macleod_summarised <-
  map_dfr(het_macleod,
          function(het) summarise(group_by(het, label), meanF = mean(F), sdF = sd(F)))



plot_het_seq <- ggplot() +
  geom_violin(aes(x = label,
                  y = F),
              data = het_seq) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  data = het_seq_summarised) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  colour = "grey",
                  size = 0.25,
                  position = position_jitter(),
                  data = bind_rows(het_seq_sim_summarised, het_macleod_summarised)) +
  geom_hline(yintercept = 0, linetype = 2) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.title = element_blank()) +
  ylab("Homozygosity inbreeding coefficient") +
  xlab("Population") +
  ylim(-0.35, 1)




## F_ROH

roh_files_chip <- paste("model_checks/", c("fjall", "rodkulla", "holstein", "srb"),
                        "_chip.hom.indiv", sep = "")

roh_chip <- pmap_dfr(list(filename = roh_files_chip,
                          label = c("Fjäll", "Rödkulla", "Swedish Holstein-Friesian", "Swedish Red")),
                     read_freq)


L <- 2.6e9

roh_chip_summarised <- 
  summarise(group_by(roh_chip, label),
            meanF = mean(KB * 1000/L),
            sdF = sd(KB * 1000/L))


roh_files_sim_chip <- paste(rep(
  paste("model_checks/gone_", c("fjall", "rodkulla", "holstein", "srb"),
        "_chip_replicate",
        sep = ""),
  each = 10),
  1:10,
  ".hom.indiv", sep = ""
)

roh_labels_sim <- tibble(case = as.character(1:length(roh_files_sim_chip)),
                         label = rep(c("Fjäll", "Rödkulla",
                                       "Swedish Holstein-Friesian", "Swedish Red"),
                                     each = 10))

roh_chip_simulated <- pmap(
  list(filename = roh_files_sim_chip,
       label = roh_labels_sim$label),
  read_freq
)

roh_chip_sim_summarised <-
  map_dfr(roh_chip_simulated,
          function(roh) 
            summarise(group_by(roh, label),
                      meanF = mean(KB * 1000/L),
                      sdF = sd(KB * 1000/L)))


roh_files_swe_seq <- paste("model_checks/", c("fjall", "rodkulla"),
                           "_seq.hom.indiv", sep = "")

roh_labels_swe_seq <- tibble(case = as.character(1:length(roh_files_swe_seq)),
                             label = c("Fjäll", "Rödkulla"))

roh_swe_seq <- pmap_dfr(list(filename = roh_files_swe_seq,
                             label = roh_labels_swe_seq$label),
                        read_freq)

roh_swe_seq_summarised <- 
  summarise(group_by(roh_swe_seq, label),
            meanF = mean(KB * 1000/L),
            sdF = sd(KB * 1000/L))



plot_roh_chip <- ggplot() +
  geom_violin(aes(x = label,
                  y = KB * 1000/L),
              data = roh_chip) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  colour = "grey",
                  size = 0.25,
                  position = position_jitter(),
                  data = roh_chip_sim_summarised) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  data = roh_chip_summarised) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  colour = "red",
                  position = position_nudge(x = 0.05),
                  data = roh_swe_seq_summarised) +
  scale_x_discrete(guide = guide_axis(n.dodge = 2)) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.title = element_blank()) +
  ylab("ROH inbreeding coefficient") +
  xlab("Population") +
  ylim(-0.05, 0.6)




## HOL, JER

roh_files_seq <- paste("model_checks/", c("holstein", "jersey"),
                       "_seq.hom.indiv", sep = "")

roh_labels_seq <- tibble(case = as.character(1:length(roh_files_seq)),
                         label = c("Holstein", "Jersey"))

roh_seq <- pmap_dfr(list(filename = roh_files_seq,
                         label = roh_labels_seq$label),
                    read_freq)

roh_seq_summarised <- 
  summarise(group_by(roh_seq, label),
            meanF = mean(KB * 1000/L),
            sdF = sd(KB * 1000/L))


roh_files_sim_seq <- paste(rep(
  paste("model_checks/gone_", c("holstein", "jersey"),
        "_seq_replicate",
        sep = ""),
  each = 10),
  1:10,
  ".hom.indiv", sep = ""
)

roh_labels_sim_seq <- tibble(case = as.character(1:length(roh_files_sim_seq)),
                             label = rep(c("Holstein", "Jersey"),
                                         each = 10))

roh_seq_simulated <- pmap(
  list(filename = roh_files_sim_seq,
       label = roh_labels_sim_seq$label),
  read_freq
)

roh_seq_sim_summarised <-
  map_dfr(roh_seq_simulated,
          function(roh) 
            summarise(group_by(roh, label),
                      meanF = mean(KB * 1000/L),
                      sdF = sd(KB * 1000/L)))


roh_files_macleod <- paste(rep(
  paste("model_checks/macleod_replicate",
        sep = ""),
  each = 10),
  1:10,
  ".hom.indiv", sep = ""
)


roh_macleod <- pmap(
  list(filename = roh_files_macleod,
       label = freq_labels_macleod$label),
  read_freq
)


roh_macleod_summarised <-
  map_dfr(roh_macleod,
          function(roh) 
            summarise(group_by(roh, label),
                      meanF = mean(KB * 1000/L),
                      sdF = sd(KB * 1000/L)))


plot_roh_seq <- ggplot() +
  geom_violin(aes(x = label,
                  y = KB * 1000/L),
              data = roh_seq) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  colour = "grey",
                  size = 0.25,
                  position = position_jitter(),
                  data = bind_rows(roh_seq_sim_summarised, roh_macleod_summarised)) +
  geom_pointrange(aes(x = label,
                      y = meanF,
                      ymin = meanF - sdF,
                      ymax = meanF + sdF),
                  data = roh_seq_summarised) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.title = element_blank()) +
  ylab("ROH inbreeding coefficient") +
  xlab("Population") +
  ylim(-0.05, 0.6)




## Combined figure

plot_freq_combined <- (plot_freq_chip / plot_freq_seq) 

plot_f_combined <- 
  (plot_het_chip | plot_het_seq) /
  (plot_roh_chip | plot_roh_seq)



pdf("figures/checks_freq.pdf",
    width = 10)
print(plot_freq_combined)
dev.off()

pdf("figures/checks_inbreeding.pdf",
    width = 10)
print(plot_f_combined)
dev.off()
