# intronology
<img src="assets/intronology-logo.png" alt="logo" width="150">

## overview
`intronology` is an R package to annotate introns from `.gff` files. 

## installation
### how to install
```
if (!requireNamespace("devtools", quietly = TRUE)) {
  install.packages("devtools")
}

devtools::install_github("AlicePierce/intronology")
```
### dependencies
- data.table
- magrittr
- dplyr

## functions
- `gffGenes()`: Extracts Gene Coordinates from GFF file
- `gffExons()`: Extracts Exon Coordinates from GFF File
- `annotateIntrons()`: Extracts Intron Coordinates from GFF file
- `intronFeatures()`: Extracts Gene, Exon & Intron coordinates and Annotates Gene Features from a GFF file

## future developments
- Function to filter by longest isoform

## license
see [LICENSE](LICENSE) for details

## getting help
Submit an [issue](https://github.com/AlicePierce/intronology/issues)

Contact Alice at <avpierce@ucdavis.edu>
