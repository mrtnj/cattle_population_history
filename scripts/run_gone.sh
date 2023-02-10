
## Run GONE over Swedish cattle breeds

if [ ! -d gone ]; then
  mkdir gone
fi


if [ ! -d gone/sequence ]; then
  mkdir gone/sequence
fi

for BREED in srb1 srb2 rodkulla bohuskulla fjall fjallnara vaneko; do

  bash scripts/gone_wrapper.sh \
    plink/sequence/$BREED \
    gone/sequence/$BREED

done


if [ ! -d gone/sequence_cM ]; then
  mkdir gone/sequence_cM
fi

for BREED in srb1 srb2 rodkulla bohuskulla fjall fjallnara vaneko; do

  bash scripts/gone_wrapper.sh \
    plink/sequence_cM/$BREED \
    gone/sequence_cM/$BREED

done
