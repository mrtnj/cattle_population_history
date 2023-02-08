
## Convert Swedish cattle variants from SNP chips


set -eu

if [ ! -d plink/snp_chip_cM ]; then
  mkdir plink/snp_chip_cM
fi


cp outputs/snp_chip_map_cM.map \
  plink/snp_chip_cM/swedish_cattle_snp_chip_lifted_cM.map
  
cp plink/snp_chip/swedish_cattle_snp_chip_lifted.ped \
  plink/snp_chip_cM/swedish_cattle_snp_chip_lifted_cM.ped


for BREED in srb skb rodkulla bohuskulla fjall fjallnara vaneko ringamala holstein; do

  plink \
    --cow \
    --mac 1 \
    --file plink/snp_chip_cM/swedish_cattle_snp_chip_lifted_cM \
    --exclude outputs/snps_to_remove_snp_chip.txt \
    --keep metadata/snp_chip_breed_files/${BREED}.txt \
    --recode \
    --out plink/snp_chip_cM/${BREED} 
  
done