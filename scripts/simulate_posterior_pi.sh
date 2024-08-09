
## Simulate pi over time from inferred histories

set -eu


HISTORIES=(gone_fjall_chip gone_holstein_chip gone_rodkulla_chip gone_srb_chip)


for IX in {0..5}; do

  for REP in {1..10}; do

    mkdir -p simulations/gone_posterior_pi/${HISTORIES[$IX]}/

    python python/simulate_posterior_pi.py \
      population_histories/${HISTORIES[$IX]}.csv \
      simulations/gone_posterior_pi/${HISTORIES[$IX]}/replicate$REP.csv
      
  done
    
done

