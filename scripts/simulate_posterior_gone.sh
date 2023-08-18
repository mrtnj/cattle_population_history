
## Create fake data of a population with one decline

set -eu

if [ ! -d simulations ]; then
  mkdir simulations
fi

if [ ! -d simulations/gone_posterior ]; then
  mkdir simulations/gone_posterior
fi


for RUN in fjall_chip holstein_chip fjall_seq; do

  for REP in 1; do

    mkdir -p simulations/gone_posterior/$RUN/replicate$REP

    Rscript R/simulate_population_history.R \
      population_histories/gone_${RUN}.csv \
      simulations/gone_posterior/$RUN/replicate$REP/ 
    
  done
    
done
