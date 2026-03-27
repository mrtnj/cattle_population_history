
## Leave one chromosome out


for REP in {1..10}; do

  mkdir -p plink/loco_decline/replicate$REP

  for CHR in {1..29}; do
  
    plink \
      --cow \
      --file simulations/decline/replicate$REP/genotypes100k \
      --not-chr $CHR \
      --recode \
      --out plink/loco_decline/replicate$REP/loco$CHR
      
    done
  
done
