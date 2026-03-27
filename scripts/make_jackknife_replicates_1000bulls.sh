


for BREED in jersey holstein; do

  mkdir -p plink/jackknife_seq_$BREED/

  Rscript R/make_jackknife_replicates.R \
    plink/sequence/$BREED \
    plink/jackknife_seq_$BREED/

done

