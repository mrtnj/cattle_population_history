
## Run GONE over simulations


for SAMPLE in {1..10}; do

  mkdir -p gone/jackknife_decline/replicate$SAMPLE

  for REP in {1..20}; do

    bash scripts/gone_wrapper.sh \
      plink/jackknife_decline/replicate$SAMPLE/jackknife$REP \
      gone/jackknife_decline/replicate$SAMPLE/jackknife$REP

  done
  
  sleep 30 ## does this help?
  
done


for SAMPLE in {8..10}; do

  mkdir -p gone/loco_decline/replicate$SAMPLE

  for REP in {1..29}; do

    bash scripts/gone_wrapper.sh \
      plink/loco_decline/replicate$SAMPLE/loco$REP \
      gone/loco_decline/replicate$SAMPLE/loco$REP

  done
  
done
