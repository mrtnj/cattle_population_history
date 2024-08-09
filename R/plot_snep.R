
library(dplyr)
library(ggplot2)
library(patchwork)
library(purrr)
library(readr)

source("R/helper_functions.R")

breed_colours <- read_csv("breed_colours.csv")

breeds_seq <- c("rodkulla", "fjall") ## ,"holstein", "jersey")

breeds_chip <- c("bohuskulla", "fjallnara", "holstein", "srb", "skb", "fjall",
                 "rodkulla", "vaneko", "ringamala")


chip_files <- paste("snep/snp_chip/", breeds_chip, ".NeAll", sep = "")
names(chip_files) <- breeds_chip

seq_files <- paste("snep/sequence/", breeds_seq, ".NeAll", sep = "")
names(seq_files) <- breeds_seq


snep_chip <- map_dfr(chip_files, read_tsv, .id = "breed")
snep_chip$run <- "chip"

snep_seq <- map_dfr(seq_files, read_tsv, .id = "breed")
snep_seq$run <- "seq"

snep <- inner_join(bind_rows(snep_chip, snep_seq),
                   breed_colours)

plot_snep <- qplot(x = GenAgo, y = Ne,
                   colour = breed_pretty,
                   data = filter(snep, GenAgo <= 200), geom = "line") +
  scale_colour_manual(
    values = snep$colour,
    limits = snep$breed_pretty
  ) +
  xlab("Generations ago") +
  ylab("Effective poupulation size") +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.title = element_blank())


pdf("figures/snep_chip.pdf",
    height = 5)
print(plot_snep)
dev.off()
  


snep_final <- filter(snep, GenAgo == min(GenAgo))
snep_final$breed_pretty <- factor(
  snep_final$breed_pretty,
  levels = snep_final$breed_pretty[order(snep_final$Ne,
                                         decreasing = TRUE)]
)

plot_final <- ggplot() +
  geom_bar(aes(x = breed_pretty,
               y = Ne, fill = breed_pretty),
           data = snep_final,
           stat = "identity") +
  geom_text(aes(x = breed_pretty, y = Ne + 20,
                label = round(Ne)),
            data = snep_final) +
  scale_fill_manual(values = snep_final$colour,
                    limits = snep_final$breed_pretty) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.position = "none") +
  xlab("") +
  ylab("Current Ne") +
  coord_flip()


pdf("figures/snep_final_ne.pdf",
    width = 10,
    height = 5)
print(plot_final)
dev.off()




plot_combined <- plot_snep | plot_final


pdf("figures/snep_combined.pdf",
    width = 10,
    height = 3.5)
print(plot_combined)
dev.off()