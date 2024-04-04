
## Create fake data 

set -eu


for REP in {1..10}; do

  mkdir -p simulations/decline/replicate$REP

  python python/simulate_decline.py \
    simulations/decline/replicate$REP/
    
done


for REP in {1..10}; do

  mkdir -p simulations/recovery/replicate$REP

  python python/simulate_recovery.py \
    simulations/recovery/replicate$REP/
    
done


for REP in {1..10}; do

  mkdir -p simulations/macleod/replicate$REP

  python python/simulate_macleod.py \
    simulations/macleod/replicate$REP/
    
done