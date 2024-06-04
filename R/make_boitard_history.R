
library(tibble)


time <- scan("population_histories/boitard2016/time_windows.txt",
             what = character())
time <- time[10:length(time)]

time <- sub(time, pattern = "\\[|\\]", replacement = "")


time <- as.numeric(time)



holstein <- scan("population_histories/boitard2016/estim_median_HOL.txt")

jersey <- scan("population_histories/boitard2016/estim_median_JER.txt")



boitard_hol <- tibble(generation = time,
                      Ne = 10^holstein)

boitard_jer <- tibble(generation = time,
                      Ne = 10^jersey)


write.csv(boitard_hol,
          file = "population_histories/boitard2016_hol.csv",
          row.names = FALSE,
          quote = FALSE)

write.csv(boitard_jer,
          file = "population_histories/boitard2016_jer.csv",
          row.names = FALSE,
          quote = FALSE)