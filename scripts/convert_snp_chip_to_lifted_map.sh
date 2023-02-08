
## Use lifted map and exclusion list to format the SNP chip genotypes
## on ARS-UCD1.2


cp outputs/snp_chip_map_lifted.map \
  plink/snp_chip/swedish_cattle_snp_chip.map

plink --file plink/snp_chip/swedish_cattle_snp_chip \
  --out plink/snp_chip/swedish_cattle_snp_chip_lifted \
  --recode --cow \
  --exclude outputs/snps_to_remove_snp_chip_lifted.txt
  
for BREED in srb skb rodkulla bohuskulla fjall fjallnara vaneko ringamala holstein; do

  plink \
    --cow \
    --mac 1 \
    --file plink/snp_chip/swedish_cattle_snp_chip_lifted \
    --exclude outputs/snps_to_remove_snp_chip.txt \
    --keep metadata/snp_chip_breed_files/${BREED}.txt \
    --recode \
    --out plink/snp_chip/${BREED} 
  
done