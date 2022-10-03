
## Run GONE over Swedish cattle breeds

if [ ! -d cattle_population_history/gone ]; then
  mkdir cattle_population_history/gone
fi


for BREED in srb rodkulla bohuskulla fjall fjallnara vaneko; do

  bash scripts/gone_wrapper.sh \
    cattle_population_history/plink/$BREED \
    cattle_population_history/gone/$BREED

done