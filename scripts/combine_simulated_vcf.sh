

## Combine files from simulations


for FOLDER in simulations/decline/* simulations/recovery/* simulations/macleod*; do
  grep -E "##fileformat|##source|##FILTER" \
    $FOLDER/chr1.vcf > \
    $FOLDER/header1.txt
  grep -E "##FORMAT|#CHROM" \
    $FOLDER/chr1.vcf > \
    $FOLDER/header3.txt
  grep "##contig" $FOLDER/chr{1..29}.vcf \
    --no-filename > \
    $FOLDER/header2.txt
  cat $FOLDER/chr{1..29}.vcf | 
    grep -v "#" > $FOLDER/genotypes_raw.vcf
  cat $FOLDER/header1.txt \
    $FOLDER/header2.txt \
    $FOLDER/header3.txt \
    $FOLDER/genotypes_raw.vcf > \
    $FOLDER/genotypes.vcf
  
  plink \
    --vcf $FOLDER/genotypes.vcf \
    --biallelic-only \
    --cow \
    --recode \
    --out $FOLDER/genotypes
done