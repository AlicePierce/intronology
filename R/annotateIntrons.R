annotateIntrons <- function(input_gff) {

  exon_data<-gffExons(input_gff)
  # Ensure input is a data.table
  exon_data <- as.data.table(exon_data)

  # Process the data to find intron coordinates
  intron_data <- exon_data %>%
    arrange(gene, start) %>%
    group_by(gene) %>%
    mutate(
      next_exon_start = lead(start),
      intron_start = stop + 1,
      intron_stop = next_exon_start - 1
    ) %>%
    filter(!is.na(intron_stop))  # Remove entries where no subsequent exon exists

  # Convert to data.table for further processing
  intron_data <- as.data.table(intron_data)

  # Select relevant columns for intron data
  intron_data <- intron_data[, .(gene, chr, intron_start, intron_stop, strand)]
  setnames(intron_data, c("gene", "chr", "intron_start", "intron_stop", "strand"), c("gene", "chr", "start", "stop", "strand"))

  # Calculate intron lengths
  intron_data[, intronLength := stop - start + 1]

  # Assign intron numbers based on order
  intron_data <- intron_data %>%
    group_by(gene) %>%
    arrange(gene, if_else(strand == "+", start, -start), .by_group = TRUE) %>%
    mutate(IntronNum = row_number()) %>%
    ungroup()

  intron_data$feature<-"Intron"

  # Return the annotated intron data
  return(as.data.table(intron_data))
}
