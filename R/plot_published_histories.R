
library(ggplot2)
library(readr)
library(patchwork)


## Macleod 2013


macleod <- read_csv("population_histories/macleod2013.csv")

macleod$generations_ago <-
  cumsum(macleod$number_of_generations[nrow(macleod):1])[nrow(macleod):1]

plot_macleod_whole <- qplot(x= generations_ago, y = Ne, data = macleod,
                            geom = "step") +
  xlim(0, 1e6) +
  ylim(0, 1e5)



## ASR GENERIC


histNe <- c(100, 500, 1500, 6000, 12000, 1e+05)
histGen <- c(0, 100, 1000, 10000, 1e+05, 1e+06)


plot_generic_whole <- qplot(x = histGen, y = histNe, geom = "step") +
  xlab("Generations ago") +
  ylab("Ne") +
  theme_bw() +
  theme(panel.grid = element_blank())



plot_generic_zoomed <- plot_generic_whole +
  coord_cartesian(xlim = c(0, 10000),
                  ylim = c(0, 8000))



plot_combined <- plot_generic_zoomed +
  inset_element(plot_generic_whole,
                left = 0.01, bottom = 0.5, right = 0.5, top = 0.99)


dir.create("figures")

pdf("figures/plot_history_asr_generic.pdf",
    height = 3.5)
print(plot_combined)
dev.off()



## Combined

combined <- tibble(Ne = c(macleod$Ne, histNe),
                   generations_ago = c(macleod$generations_ago, histGen),
                   model = c(rep("MacLeod et al. 2013", nrow(macleod)),
                             rep("ASR GENERIC", length(histGen))))


plot_whole <- qplot(x = generations_ago, y = Ne, geom = "step", colour = model,
                    data = combined) +
  scale_color_manual(values = c("blue", "red")) +
  xlab("Generations ago") +
  ylab("Ne") +
  theme_bw() +
  theme(panel.grid = element_blank(),
        legend.position = c(0.15, 0.8),
        legend.title = element_blank())
  


plot200 <- plot_whole +
  coord_cartesian(xlim = c(0, 200),
                  ylim = c(0, 2000)) +
  theme(legend.position = "none")



pdf("figures/published_histories.pdf",
    height = 5)
print(plot_whole / plot200)
dev.off()
