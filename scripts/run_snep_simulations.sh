
## Run SNeP over simulations

SNEP_PATH=/home/martin/tools/snep/

mkdir -p snep/simulations_decline
mkdir -p snep/simulations_recovery
mkdir -p snep/simulations_macleod


for REP in {1..10}; do

  $SNEP_PATH/SNeP_111 \
    -ped simulations_decline/replicate$REP/genotypes100k \
    -out snep/simulations_decline/replicate$REP \
    -samplesize 2 \
    -haldane > snep/decline/${REP}_out.txt

done


for REP in {1..10}; do

  $SNEP_PATH/SNeP_111 \
    -ped simulations_recovery/replicate$REP/genotypes100k \
    -out snep/simulations_recovery/replicate$REP \
    -samplesize 2 \
    -haldane > snep/recovery/${REP}_out.txt

done


for REP in {1..10}; do

  $SNEP_PATH/SNeP_111 \
    -ped simulations_macleod/replicate$REP/genotypes100k \
    -out snep/simulations_macleod/replicate$REP \
    -samplesize 2 \
    -haldane > snep/macleod/${REP}_out.txt

done
