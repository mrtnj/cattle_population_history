read_gone_results <- function(base_path, breeds, run_name) { 
  
  files <- paste(base_path, breeds, "/Output_Ne_data", sep = "")
  names(files) <- breeds
  
  gone <- map_dfr(files,
                  read_tsv,
                  skip = 1,
                  .id = "breed")
  
  gone$run <- run_name
  
  gone
  
}
