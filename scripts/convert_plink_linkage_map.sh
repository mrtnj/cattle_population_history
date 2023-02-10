
## Convert Swedish cattle variants for population history inference,
## with interpolated linkage map


set -eu


if [ ! -d plink/sequence_cM ]; then
  mkdir plink/sequence_cM
fi


cp plink/sequence/swedish_cattle_biallelic_snps.ped \
  plink/sequence_cM/swedish_cattle_biallelic_snps_cM.ped

cp outputs/snp_map_cM.map \
  plink/sequence_cM/swedish_cattle_biallelic_snps_cM.map


for BREED in srb1 srb2 rodkulla bohuskulla fjall fjallnara vaneko; do

  plink \
    --cow \
    --mac 1 \
    --file plink/sequence_cM/swedish_cattle_biallelic_snps_cM \
    --exclude outputs/snps_to_remove.txt \
    --keep metadata/breed_files/${BREED}.txt \
    --recode \
    --out plink/sequence_cM/${BREED}

done