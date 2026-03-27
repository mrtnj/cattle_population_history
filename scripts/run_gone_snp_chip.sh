
## Run GONE over Swedish cattle breeds

if [ ! -d gone/snp_chip ]; then
  mkdir gone/snp_chip
fi


for BREED in srb skb rodkulla bohuskulla fjall fjallnara vaneko ringamala holstein; do

  bash scripts/gone_wrapper.sh \
    plink/snp_chip/$BREED \
    gone/snp_chip/$BREED

done