
## Convert the SNP chip files to ped/map format to easily be able to manipulate
## the map

if [ ! -d plink/snp_chip ]; then
  mkdir plink/snp_chip
fi

plink --bfile snp_chip_data/MergedSwedishCattleB \
  --out plink/snp_chip/swedish_cattle_snp_chip \
  --recode --cow
  
