#' @import data.table

isRepresentative <- function(data_table, representative_genes_file) {
  
  # Read the representative genes file
  representative_genes <- fread(representative_genes_file, header = FALSE, col.names = "gene")
  
  # Ensure data_table is a data.table
  data_table <- as.data.table(data_table)
  
  # Filter data_table to keep only rows with genes in the representative list
  filtered_data <- data_table[gene %in% representative_genes$gene]
  
  return(filtered_data)
}