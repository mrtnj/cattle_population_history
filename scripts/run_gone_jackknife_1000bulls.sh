


for BREED in holstein jersey; do

  mkdir -p gone/jackknife_seq_$BREED
  
  N_REP=$(ls plink/jackknife_seq_$BREED/*.ped | wc -l)

  for REP in $(seq 1 $N_REP); do

    bash scripts/gone_wrapper.sh \
      plink/jackknife_seq_$BREED/jackknife$REP \
      gone/jackknife_seq_$BREED/jackknife$REP

  done
  
done
