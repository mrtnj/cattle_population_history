
## Convert Swedish cattle variants from ForestQC for population history inference


set -eu

if [ ! -d cattle_population_history ]; then
  mkdir cattle_population_history
fi

if [ ! -d cattle_population_history/plink ]; then
  mkdir cattle_population_history/plink
fi


plink \
  --cow \
  --chr 1-29 \
  --biallelic-only strict \
  --snps-only \
  --vcf vcf/swedish_cattle_forestqc.vcf.gz \
  --recode \
  --out cattle_population_history/plink/swedish_cattle_biallelic_snps 

cp cattle_population_history/outputs/snp_map_cM.map \
  cattle_population_history/plink/swedish_cattle_biallelic_snps.map


for BREED in srb rodkulla bohuskulla fjall fjallnara vaneko; do

  plink \
    --cow \
    --mac 1 \
    --file cattle_population_history/plink/swedish_cattle_biallelic_snps \
    --exclude cattle_population_history/outputs/snps_to_remove.txt \
    --keep metadata/breed_files/${BREED}.txt \
    --recode \
    --out cattle_population_history/plink/${BREED} 
  
done