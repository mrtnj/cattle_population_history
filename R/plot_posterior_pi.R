
## Plot simulations of pi over time

library(dplyr)
library(ggplot2)
library(purrr)
library(readr)
library(tibble)


files <- system("ls simulations/gone_posterior_pi/*/*.csv",
                intern = TRUE)

metadata <- tibble(run = as.character(1:length(files)),
                   file = files)
metadata$case <- ""
metadata$case[grepl("fjall", metadata$file)] <- "Fjäll"
metadata$case[grepl("holstein_chip", metadata$file)] <- "Swedish Holstein-Friesian"
metadata$case[grepl("rodkulla", metadata$file)] <- "Red Polled"
metadata$case[grepl("srb", metadata$file)] <- "Swedish Red"


pi <- map_dfr(files, read_csv, .id = "run")

pi_metadata <- inner_join(pi, metadata)


plot_pi <- qplot(x = gen - 200, y = pi,
                 alpha = I(1/5),
                 data = pi_metadata, geom = "line", group = run) +
  facet_wrap(~ case, scales = "free_y") +
  geom_vline(xintercept = 0, linetype = 2) +
  theme_bw() +
  theme(panel.grid = element_blank(),
        strip.background = element_blank()) +
  xlab("Generations ago") +
  ylab(expression("Nucleotide diversity" ~(pi))) +
  ylim(0, NA)



pdf("figures/posterior_pi.pdf",
    height = 3.5)
print(plot_pi)
dev.off()
