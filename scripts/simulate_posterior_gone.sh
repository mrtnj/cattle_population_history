
## Create fake data of a population with one decline

set -eu

if [ ! -d simulations/gone_posterior ]; then
  mkdir simulations/gone_posterior
fi


for RUN in fjall_chip fjall_seq holstein_chip; do

  for REP in 1; do

    mkdir simulations/gone_posterior/$RUN/replicate$REP

    Rscript R/simulate_population_history.R \
      population_histories/gone_${RUN}.csv \
      simulations/decline/replicate$REP/
    
  done
    
done
