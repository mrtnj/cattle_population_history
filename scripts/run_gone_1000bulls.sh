
## Run GONE over Swedish cattle breeds


for BREED in jersey holstein; do

  bash scripts/gone_wrapper.sh \
    plink/sequence/$BREED \
    gone/sequence/$BREED

done
