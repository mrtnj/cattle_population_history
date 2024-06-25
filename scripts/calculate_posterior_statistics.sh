

## Calculate population genetic statistics from real and simulated data


if [ ! -d model_checks ]; then
  mkdir model_checks
fi

## Simulations

for RUN in \
  gone_fjall_chip gone_holstein_chip gone_rodkulla_chip \
  gone_srb_chip; do

  for REP in {1..10}; do
  
    plink \
      --file simulations/gone_posterior/$RUN/replicate$REP/genotypes100k \
      --cow \
      --out model_checks/${RUN}_replicate$REP \
      --freq \
      --het \
      --homozyg
      
  done
    
done


for RUN in gone_holstein_seq gone_jersey_seq; do

  for REP in {1..10}; do
  
    plink \
      --file simulations/gone_posterior/$RUN/replicate$REP/genotypes \
      --cow \
      --out model_checks/${RUN}_replicate$REP \
      --freq \
      --het \
      --homozyg \
      --homozyg-window-het 3 \
      --homozyg-window-missing 10 
      
  done
    
done


## Real data


for BREED in holstein jersey fjall rodkulla; do

  plink \
    --file plink/sequence/$BREED \
    --cow \
    --out model_checks/${BREED}_seq \
    --freq \
    --het \
    --homozyg \
    --homozyg-window-het 3 \
    --homozyg-window-missing 10 
    
done


for BREED in holstein fjall rodkulla srb; do

  plink \
    --file plink/snp_chip/$BREED \
    --cow \
    --out model_checks/${BREED}_chip \
    --freq \
    --het \
    --homozyg
    
done



## Macleod

for REP in {1..10}; do
  
  plink \
    --file simulations/macleod_posterior/replicate$REP/genotypes \
    --cow \
    --out model_checks/macleod_replicate$REP \
    --freq \
    --het \
    --homozyg \
    --homozyg-window-het 3 \
    --homozyg-window-missing 10 
      
done