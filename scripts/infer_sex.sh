
# Extract X chromosome for sexing

# SNP chip 

plink --bfile snp_chip_data/MergedSwedishCattleB \
  --chr X Y \
  --out plink/snp_chip/swedish_cattle_chrXY \
  --recode --cow

plink --file plink/snp_chip/swedish_cattle_chrXY \
  --check-sex ycount --cow \
  --out plink/snp_chip/swedish_cattle_chrXY


# 1000 bulls

VCF_PATH=/home/martin/variants/1000bulls_run9_public/


bcftools view -Oz -S metadata/breed_files/1000bulls_holstein.txt \
  $VCF_PATH/ChrX-Run9-PUBLIC-rehead-v2-toDistribute.vcf.gz > \
  vcf/holstein_chrX.vcf.gz

bcftools view -Oz -S metadata/breed_files/1000bulls_jersey.txt \
  $VCF_PATH/ChrX-Run9-PUBLIC-rehead-v2-toDistribute.vcf.gz > \
  vcf/jersey_chrX.vcf.gz


gatk IndexFeatureFile -I vcf/holstein_chrX.vcf.gz
gatk IndexFeatureFile -I vcf/jersey_chrX.vcf.gz

gatk SelectVariants \
-V vcf/holstein_chrX.vcf.gz \
--exclude-filtered \
-O vcf/holstein_chrX_filtered_excluded.vcf.gz

gatk SelectVariants \
-V vcf/jersey_chrX.vcf.gz \
--exclude-filtered \
-O vcf/jersey_chrX_filtered_excluded.vcf.gz

plink \
  --cow \
  --biallelic-only strict \
  --snps-only \
  --vcf vcf/holstein_chrX_filtered_excluded.vcf.gz \
  --recode \
  --out plink/sequence/holstein_chrX
  
plink --file plink/sequence/holstein_chrX \
  --check-sex ycount --cow \
  --out plink/sequence/holstein_chrX


plink \
  --cow \
  --biallelic-only strict \
  --snps-only \
  --vcf vcf/jersey_chrX_filtered_excluded.vcf.gz \
  --recode \
  --mac 1 \
  --out plink/sequence/jersey_chrX
  
  
plink --file plink/sequence/jersey_chrX \
  --check-sex ycount --cow \
  --out plink/sequence/jersey_chrX