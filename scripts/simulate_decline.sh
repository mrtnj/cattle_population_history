
## Create fake data of a population with one decline

set -eu

if [ ! -d simulations/decline ]; then
  mkdir simulations/decline
fi


for REP in {1..10}; do

  mkidr simulations/decline/replicate$REP

  Rscript R/simulate_population_decline.R \
    simulations/decline/replicate$REP/
    
done
