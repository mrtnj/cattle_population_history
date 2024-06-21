
# Extract Holstein and Jersey samples from 1000 bulls for GONE

VCF_PATH=/home/martin/variants/1000bulls_run9_public/

if [ ! -d vcf ]; then
  mkdir vcf
fi

for CHR in {1..29}; do
  bcftools view -Oz -S metadata/breed_files/1000bulls_holstein.txt \
    $VCF_PATH/Chr${CHR}-Run9-PUBLIC-rehead-v2-toDistribute.vcf.gz > \
    vcf/holstein_chr${CHR}.vcf.gz

  bcftools view -Oz -S metadata/breed_files/1000bulls_jersey.txt \
    $VCF_PATH/Chr${CHR}-Run9-PUBLIC-rehead-v2-toDistribute.vcf.gz > \
    vcf/jersey_chr${CHR}.vcf.gz
done


bcftools concat vcf/jersey_chr{1..29}.vcf.gz -Oz -o vcf/jersey.vcf.gz
bcftools concat vcf/holstein_chr{1..29}.vcf.gz -Oz -o vcf/holstein.vcf.gz


gatk IndexFeatureFile -I vcf/holstein.vcf.gz
gatk IndexFeatureFile -I vcf/jersey.vcf.gz

gatk SelectVariants \
-V vcf/holstein.vcf.gz \
--exclude-filtered \
-O vcf/holstein_filtered_excluded.vcf.gz

gatk SelectVariants \
-V vcf/jersey.vcf.gz \
--exclude-filtered \
-O vcf/jersey_filtered_excluded.vcf.gz

plink \
  --cow \
  --chr 1-29 \
  --biallelic-only strict \
  --snps-only \
  --vcf vcf/holstein_filtered_excluded.vcf.gz \
  --recode \
  --maf 0.000001 \
  --out plink/sequence/holstein


plink \
  --cow \
  --chr 1-29 \
  --biallelic-only strict \
  --snps-only \
  --vcf vcf/jersey_filtered_excluded.vcf.gz \
  --recode \
  --maf 0.000001 \
  --out plink/sequence/jersey