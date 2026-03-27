
library(dplyr)
library(ggplot2)
library(patchwork)
library(readr)



pca <- read_delim("plink/sequence/holstein_pca.eigenvec", delim = " ", col_names = FALSE)
colnames(pca) <- c("FID", "IID", paste0("PC", 1:(ncol(pca) - 2)))


plot_hol_unfiltered <- qplot(x = PC1, y = PC2, data = pca)

to_filter <- pca$IID[c(which.max(pca$PC1), which.min(pca$PC2))]

plot_hol_filtered <- qplot(x = PC1, y = PC2, data = filter(pca, !IID %in% to_filter)) +
  theme_classic()




jersey <- read_delim("plink/sequence/jersey_pca.eigenvec", delim = " ", col_names = FALSE)
colnames(jersey) <- c("FID", "IID", paste0("PC", 1:(ncol(jersey) - 2)))


plot_jer <- qplot(x = PC1, y = PC2, data = jersey) + theme_classic()





plot_combined <- (plot_hol_filtered + ggtitle("Holstein")) /
  (plot_jer + ggtitle("Jersey"))


pdf("figures/pca_1000bulls.pdf")
print(plot_combined)
dev.off()


write(paste(to_filter, to_filter),
      file = "plink/1000bulls_to_exclude.txt",
      sep = "\n")
