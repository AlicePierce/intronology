gffGenes <- function(input_gff) {

  # Read the GFF file
  gff_data <- fread(input_gff, sep = "\t", header = FALSE, data.table = FALSE)

  # Filter rows where the third column (type) is "mRNA"
  allGenes <- gff_data[gff_data[, 3] == "mRNA", ]

  # Remove unnecessary columns (V2, V3, V6, V8)
  allGenes <- allGenes[, -c(2, 3, 6, 8)]

  # Rename columns
  colnames(allGenes) <- c("chr", "start", "stop", "strand", "gene")

  # Clean and filter data
  allGenes$chr <- gsub("Chr", "", allGenes$chr)  # Remove "Chr" prefix
  allGenes$gene <- gsub("ID=", "", allGenes$gene)  # Remove "ID=" prefix
  allGenes$gene <- gsub(";.*", "", allGenes$gene)  # Remove trailing metadata

  allGenes$geneLength <- allGenes$stop - allGenes$start + 1  # Calculate gene length

  # Return the processed table
  return(allGenes)
}
