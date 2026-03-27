


for BREED in srb skb rodkulla bohuskulla fjall fjallnara vaneko ringamala holstein; do

  mkdir -p plink/jackknife_$BREED/

  Rscript R/make_jackknife_replicates.R \
    plink/snp_chip/$BREED \
    plink/jackknife_$BREED/

done

