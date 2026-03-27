


for BREED in srb skb rodkulla bohuskulla fjall fjallnara vaneko ringamala holstein; do

  mkdir -p gone/jackknife_$BREED
  
  N_REP=$(ls plink/jackknife_$BREED/*.ped | wc -l)

  for REP in $(seq 1 $N_REP); do

    bash scripts/gone_wrapper.sh \
      plink/jackknife_$BREED/jackknife$REP \
      gone/jackknife_$BREED/jackknife$REP

  done
  
done
