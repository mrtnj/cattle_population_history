
## Run SNeP over simulations

SNEP_PATH=/home/martin/tools/snep/

mkdir -p snep/simulations_decline
mkdir -p snep/simulations_recovery
mkdir -p snep/simulations_macleod


for REP in {1..10}; do

  $SNEP_PATH/SNeP_111 \
    -ped simulations/decline/replicate$REP/genotypes100k.ped \
    -out snep/simulations_decline/replicate$REP \
    -samplesize 2 \
    -haldane > snep/simulations_decline/replicate${REP}_out.txt

done


for REP in {1..10}; do

  $SNEP_PATH/SNeP_111 \
    -ped simulations/recovery/replicate$REP/genotypes100k.ped \
    -out snep/simulations_recovery/replicate$REP \
    -samplesize 2 \
    -haldane > snep/simulations_recovery/replicate${REP}_out.txt

done


for REP in {1..10}; do

  $SNEP_PATH/SNeP_111 \
    -ped simulations/macleod/replicate$REP/genotypes100k.ped \
    -out snep/simulations_macleod/replicate$REP \
    -samplesize 2 \
    -haldane > snep/simulations_macleod/replicate${REP}_out.txt

done
