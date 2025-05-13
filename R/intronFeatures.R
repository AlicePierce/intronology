intronFeatures <- function(input_gff) {

  allIntrons<-annotateIntrons(input_gff)
  allExons<-gffExons(input_gff)
  allGenes<-gffGenes(input_gff)

  allIntrons <- allIntrons %>% group_by(gene) %>%
    mutate(totalIntronLength=sum(intronLength))
  allIntrons<-as.data.table(allIntrons)

  firstIntrons<-allIntrons[IntronNum==1] %>% select(gene, intronLength, totalIntronLength)

  allExons<-left_join(allExons, firstIntrons, by="gene")
  allExons<-allExons %>% group_by(gene) %>%
    mutate(totalexonNum=n(), totalintronNum=n()-1, totalExonLength=sum(exonLength))
  allExons<-as.data.table(allExons)

  firstExons<-allExons[ExonNum==1]
  firstExons$firstintronpos<-ifelse(firstExons$totalintronNum == 0, NA, firstExons$exonLength + 1)
  names(firstExons)[names(firstExons) == "intronLength"] <- "firstIntronLength"
  names(firstExons)[names(firstExons) == "exonLength"] <- "firstExonLength"

  allGenes<-as.data.table(allGenes)
  firstExons <- left_join(firstExons, allGenes[, .(gene, geneLength)], by = "gene")

  firstExons <- firstExons[, !c("feature", "start","stop"), with = FALSE]

  return(list(allGenes=allGenes, allExons=allExons,allIntrons=allIntrons, IntronFeatures=firstExons))
}
