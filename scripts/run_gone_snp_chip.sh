
## Run GONE over Swedish cattle breeds

if [ ! -d gone/snp_chip ]; then
  mkdir gone/snp_chip
fi

if [ ! -d gone/snp_chip_cM ]; then
  mkdir gone/snp_chip_cM
fi

for BREED in srb skb rodkulla bohuskulla fjall fjallnara vaneko ringamala holstein; do

  bash scripts/gone_wrapper.sh \
    plink/snp_chip/$BREED \
    gone/snp_chip/$BREED
    
  bash scripts/gone_wrapper.sh \
    plink/snp_chip_cM/$BREED \
    gone/snp_chip_cM/$BREED

done