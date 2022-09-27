
## Convert Swedish cattle variants from ForestQC for population history inference


set -eu

if [ ! -d cattle_population_history ]; then
  mkdir cattle_population_history
fi

if [ ! -d cattle_population_history/plink ]; then
  mkdir cattle_population_history/plink
fi


for BREED in srb rodkulla bohuskulla fjall fjallnara vaneko; do

  plink \
    --cow \
    --chr 1-29 \
    --biallelic-only strict \
    --snps-only \
    --vcf vcf/swedish_cattle_forestqc.vcf.gz \
    --keep metadata/breed_files/${BREED}.txt \
    --recode \
    --out cattle_population_history/plink/${BREED} 
  
done