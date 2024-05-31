
## Simulate data for posterior checks

set -eu


HISTORIES=(gone_fjall_chip gone_holstein_chip gone_rodkulla_chip \
  gone_holstein_seq gone_jersey_seq gone_srb_chip)
N_SAMPLES=(23 24 18 146 77 25)


for IX in {0..5}; do

  for REP in {1..10}; do

    mkdir -p simulations/gone_posterior/${HISTORIES[$IX]}/replicate$REP

    python python/simulate_posterior.py \
      population_histories/${HISTORIES[$IX]}.csv \
      ${N_SAMPLES[$IX]} \
      simulations/gone_posterior/${HISTORIES[$IX]}/replicate$REP
      
  done
    
done

