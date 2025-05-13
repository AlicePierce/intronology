gffExons <- function(input_gff) {

  # Read the GFF file
  gff_data <- fread(input_gff, sep = "\t", header = FALSE, data.table = FALSE)

  # Filter rows where the third column (type) is "exon"
  allExons <- gff_data[gff_data[, 3] == "exon", ]

  # Remove unnecessary columns (V2, V3, V6, V8)
  allExons <- allExons[, -c(2, 3, 6, 8)]

  # Rename columns
  colnames(allExons) <- c("chr", "start", "stop", "strand", "gene")

  # Clean and filter data
  allExons$chr <- gsub("Chr", "", allExons$chr)  # Remove "Chr" prefix
  allExons$gene <- gsub("Parent=", "", allExons$gene)  # Remove "ID=" prefix
  allExons$gene <- gsub("ID=", "", allExons$gene)  # Remove "ID=" prefix
  allExons$gene <- gsub(";.*", "", allExons$gene)  # Remove trailing metadata
  allExons$gene <- gsub(".exon.*", "", allExons$gene)  # Remove trailing metadata

  # Extract exon feature and calculate exon length
  allExons$feature <- "Exon"
  allExons$exonLength <- allExons$stop - allExons$start + 1

  # Assign exon numbers within each gene, considering strand
  allExons <- allExons %>%
    group_by(gene) %>%
    arrange(gene, if_else(strand == "+", start, -start), .by_group = TRUE) %>%  # Sort by strand
    mutate(ExonNum = row_number()) %>%  # Add sequential exon number
    ungroup()

  return(allExons)
}
