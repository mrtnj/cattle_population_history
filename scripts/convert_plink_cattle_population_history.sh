
## Convert Swedish cattle variants for population history inference


set -eu


if [ ! -d plink/sequence ]; then
  mkdir plink/sequence
fi

if [ ! -d plink/sequence_cM ]; then
  mkdir plink/sequence_cM
fi


plink \
  --cow \
  --chr 1-29 \
  --biallelic-only strict \
  --snps-only \
  --vcf ../vcf/swedish_cattle_snps_filtered_excluded_missing_set.vcf.gz \
  --recode \
  --out plink/sequence/swedish_cattle_biallelic_snps 


for BREED in srb1 srb2 rodkulla bohuskulla fjall fjallnara vaneko; do

  plink \
    --cow \
    --mac 1 \
    --file plink/sequence/swedish_cattle_biallelic_snps \
    --keep metadata/breed_files/${BREED}.txt \
    --recode \
    --out plink/sequence/${BREED} 
  
done
 
# cp plink/sequence/swedish_cattle_biallelic_snps.ped \
#   plink/snp_chip_cM/swedish_cattle_biallelic_snps_cM.ped
# 
# cp outputs/snp_map_cM.map \
#   plink/sequencing_cM/swedish_cattle_biallelic_snps_cM.map
# 
# 
# for BREED in srb1 srb2 rodkulla bohuskulla fjall fjallnara vaneko; do
# 
#   plink \
#     --cow \
#     --mac 1 \
#     --file plink/swedish_cattle_biallelic_snps \
#     --exclude outputs/snps_to_remove.txt \
#     --keep metadata/breed_files/${BREED}.txt \
#     --recode \
#     --out cattle_population_history/plink/${BREED} 
#   
# done