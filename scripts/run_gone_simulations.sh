
## Run GONE over simulations


mkdir -p gone/simulations_decline
mkdir -p gone/simulations_two_declines
mkdir -p gone/simulations_recovery
mkdir -p gone/simulations_macleod


for REP in {1..10}; do

  bash scripts/gone_wrapper.sh \
    simulations/decline/replicate$REP/genotypes100k \
    gone/simulations_decline/replicate$REP

done


for REP in {1..10}; do

  bash scripts/gone_wrapper.sh \
    simulations/two_declines/replicate$REP/genotypes100k \
    gone/simulations_two_declines/replicate$REP

done


for REP in {1..10}; do

  bash scripts/gone_wrapper.sh \
    simulations/recovery/replicate$REP/genotypes100k \
    gone/simulations_recovery/replicate$REP

done


for REP in {1..10}; do

  bash scripts/gone_wrapper.sh \
    simulations/macleod/replicate$REP/genotypes100k \
    gone/simulations_macleod/replicate$REP

done
