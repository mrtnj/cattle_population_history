## Linear interpolation of genetic marker position

interpolate_cM <- function(marker_pos,
                           bp_before,
                           bp_after,
                           cM_before,
                           cM_after) {
  
  delta_bp <- bp_after - bp_before
  delta_cM <- cM_after - cM_before
  
  cM_per_bp <- delta_cM/delta_bp
  
  cM_before +  cM_per_bp * (marker_pos - bp_before)
}


interpolate_chromosome <- function(map_chr, linkage_map_chr) {
  n_variants <- nrow(map_chr)
  
  cM <- numeric(n_variants)
  
  for (variant_ix in 1:n_variants) {
    
    marker_pos <- map_chr$bp[variant_ix]
    
    ix_before <- max(which(linkage_map_chr$position_bp < marker_pos))
    ix_after <- min(which(linkage_map_chr$position_bp > marker_pos))
    
    
    if (ix_after == 1) {
      cM_position <- NA
    } else {
      ## Most cases
      cM_position <- interpolate_cM(marker_pos,
                                    bp_before = linkage_map_chr$position_bp[ix_before],
                                    bp_after = linkage_map_chr$position_bp[ix_after],
                                    cM_before = linkage_map_chr$position_cM[ix_before],
                                    cM_after = linkage_map_chr$position_cM[ix_after])
    }
    
    cM[variant_ix] <- cM_position
    
  }
  cM 
}

## Interpolate each chromosome

interpolate_genome <- function(map, linkage_map) {
  
  map_split <- split(map, map$chr)
  
  n_chr <- length(map_split)
  
  for (chr_ix in 1:n_chr) {
    
    chr <- unique(map_split[[chr_ix]]$chr)
    
    linkage_map_chr <- linkage_map[linkage_map$chr == chr,]
    
    map_split[[chr_ix]]$cM <- interpolate_chromosome(map_split[[chr_ix]],
                                                     linkage_map_chr)
    
  }
  
  map_cM <- bind_rows(map_split)
  
  map_cM
  
}
