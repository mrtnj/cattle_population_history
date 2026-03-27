

plink --file plink/sequence/holstein \
  --cow --pca \
  --out plink/sequence/holstein_filtered_pca
  
  
plink --file plink/sequence/holstein_unfiltered \
  --cow --pca \
  --out plink/sequence/holstein_pca


plink --file plink/sequence/jersey \
  --cow --pca \
  --out plink/sequence/jersey_pca
