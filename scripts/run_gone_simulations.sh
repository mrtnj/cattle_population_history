
## Run GONE over simulations


mkdir -p gone/simulations_decline
mkdir -p gone/simulations_recovery
mkdir -p gone/simulations_macleod


for REP in {1..10}; do

  bash scripts/gone_wrapper.sh \
    simulations/decline/replicate$REP/genotypes \
    gone/simulations_decline/replicate$REP

done


for REP in {1..10}; do

  bash scripts/gone_wrapper.sh \
    simulations/recovery/replicate$REP/genotypes \
    gone/simulations_recovery/replicate$REP

done


for REP in {1..10}; do

  bash scripts/gone_wrapper.sh \
    simulations/macleod/replicate$REP/genotypes \
    gone/simulations_macleod/replicate$REP

done
