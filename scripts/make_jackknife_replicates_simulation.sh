


for REP in {1..10}; do

  mkdir -p plink/jackknife_decline/replicate$REP

  Rscript R/make_jackknife_replicates.R \
    simulations/decline/replicate$REP/genotypes100k \
    plink/jackknife_decline/replicate$REP/
  
done
