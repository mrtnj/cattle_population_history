

SNEP_PATH=/home/martin/tools/snep/


mkdir -p snep/sequence
mkdir -p snep/snp_chip

for POP in snp_chip/fjall snp_chip/fjallnara snp_chip/holstein snp_chip/bohuskulla \
  snp_chip/ringamala snp_chip/rodkulla snp_chip/skb snp_chip/srb snp_chip/vaneko \
  sequence/fjall sequence/rodkulla sequence/holstein sequence/jersey; do

  $SNEP_PATH/SNeP_111 \
    -ped plink/${POP}.ped \
    -out snep/$POP \
    -samplesize 2 \
    -haldane > snep/${POP}_out.txt
  
done
