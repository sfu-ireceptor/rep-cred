plotStats<-function(data,stats , main_text , xlab_text){
  min_val <- stats$min[1]
  max_val <- stats$max[1]
  mean_val<-stats$mean[1]
  quantile_5 <- stats$percentile_5[1]
  quantile_95 <-stats$percentile_95[1]
  sd_val <-stats$standard_dev[1]
  
  
  hist(data,main=main_text , xlab=xlab_text)
  abline(v=quantile_5,col="light blue")
  abline(v=quantile_95,col="light blue")
  abline(v=min_val , col="red")
  abline(v=max_val , col="red")
  abline(v=mean_val,col="dark blue")
  arrows(x0=(mean_val-sd_val), y0=max(table(data)),x1=(mean_val+sd_val),col="dark blue",code=3,lwd=2)
  #legend("topright",c("Mean +- standard dev","5% and 95% quantile points","Min and Max Value points"),fill=c("Dark blue","light blue","red"))
  
  
}

CDR3pairwiseDistanceInfo <- function(data){
    cdr3_pairwise_distance = getCDR3PairwiseDistanceDistribution(data)
    stats <- getCoreStats(cdr3_pairwise_distance)
    plotStats(cdr3_pairwise_distance,stats,"Histogram of CDR 3 pairwise distance distribtuion", "Distance value")
    kbl(stats)
  }


nearestNeighbourDistInfo <- function(data){
  nn_distribution = getNearestNeighborDistribution(data)
  stats <- getCoreStats(nn_distribution)
  plotStats(nn_distribution,stats,"Histogram of Nearest Neighbour distance distribtuion", "Distance value")
  kbl(stats)
  
} 

pairwiseDistDistribution <- function(data){
  pairwise_distribution = getPairwiseDistanceDistribution(data,column = "sequence")
  stats <- getCoreStats(pairwise_distribution)
  plotStats(pairwise_distribution,stats,"Histogram of Pairwise Distance distribtuion", "Distance value")
  kbl(stats)
}

gcContentDistribution<- function(data){
  if(anyNA(data$sequence_alignment)){
    gc_distribution = getGCContentDistribution(data, column="sequence") 
    
  }else{
    gc_distribution = getGCContentDistribution(data) 
  }
  stats <- getCoreStats(gc_distribution)
  plotStats(gc_distribution,stats,"Histogram of GC content distribtuion", "GC Content")
  kbl(stats)
}

aliphaticDistribution<- function(data){
  aliph_distribution = getAliphaticIndexDistribution(data)
  stats <- getCoreStats(aliph_distribution)
  plotStats(aliph_distribution,stats,"Histogram of Aliphatic Index distribtuion", "Aliphatic Index")
  kbl(stats)
}

GRAVYDistribution<- function(data){
  gravy_distribution = getGRAVYDistribution(data)
  stats <- getCoreStats(gravy_distribution)
  plotStats(gravy_distribution,stats,"Histogram of GRAVY distribtuion", "GRAVY indices")
  kbl(stats)
}

positionDistancesBetweenMutationDistribution <- function(data){
  pos_distribution<-getPositionalDistanceBetweenMutationsDistribution(data)
  stats <- getCoreStats(pos_distribution)
  plotStats(pos_distribution,stats,"Histogram of distance between mutations", "Distance value")
  kbl(stats)
}

distanceFromGermlineToSequenceDistribution <- function(data){
  lev_distribution_germline_to_seq<-getDistanceFromGermlineToSequenceDistribution(data)
  stats <- getCoreStats(lev_distribution_germline_to_seq)
  plotStats(lev_distribution_germline_to_seq,stats,"Histogram of levenshtein from germline alignment to sequence alignment", "Distance value")
  kbl(stats)
}

perGeneMutationRates <- function(data){
  gene_mut <- getPerGeneMutationRates(data)
  stats <- getCoreStats(gene_mut)
  plotStats(gene_mut,stats,"Histogram of gene mutation rates", "Mutation Rate Value")
  kbl(stats)
}

perGenePerPositionMutationRates <- function(data){
  gene_mut_pos <- perGenePerPositionMutationRates(data)
  stats <- getCoreStats(gene_mut_pos)
  plotStats(gene_mut_pos,stats,"Histogram of gene mutation rates , per position", "Mutation Rate Value per Position")
  kbl(stats)
}

hotspotCountDist <- function(data){
  hotspot <- getHotspotCountDistribution(data)
  stats <- getCoreStats(hotspot)
  plotStats(hotspot,stats,"Histogram of Hotspot count distribution", "Hotspot Count")
  kbl(stats)
}

coldspotCountDist <- function(data){
  coldspot <- getColdspotCountDistribution(data)
  stats <- getCoreStats(coldspot)
  plotStats(coldspot,stats,"Histogram of Coldspot count distribution", "Coldspot Count")
  kbl(stats)
}

polarityDistribution <- function(data){
  polarity <- getPolarityDistribution(data)
  stats <- getCoreStats(polarity)
  plotStats(polarity,stats,"Histogram of polarity distribution", "Polarity Value")
  kbl(stats)
}

chargeDistribution <- function(data){
  charge <- getChargeDistribution(data)
  stats <- getCoreStats(charge)
  plotStats(charge,stats,"Histogram of charge distribution", "Charge Value")
  kbl(stats)
}

basicityDistribution <- function(data){
  basicity <- getBasicityDistribution(data)
  stats <- getCoreStats(basicity)
  plotStats(basicity,stats,"Histogram of basicity distribution", "Basicity Value")
  kbl(stats)
}

acidityDistribution <- function(data){
  acidity <- getAcidityDistribution(data)
  stats <- getCoreStats(acidity)
  plotStats(acidity,stats,"Histogram of acidity distribution", "Acidity Value")
  kbl(stats)
}

aromaticityDistribution <- function(data){
  aromaticity <- getAromaticityDistribution(data)
  stats <- getCoreStats(aromaticity)
  plotStats(aromaticity,stats,"Histogram of aromaticity distribution", "Aromaticity Value")
  kbl(stats)
}

bulkinessDistribution <- function(data){
  bulkiness <- getBulkinessDistribution(data)
  stats <- getCoreStats(bulkiness)
  plotStats(bulkiness,stats,"Histogram of bulkiness distribution", "Bulkiness Value")
  kbl(stats)
}

VDinsertionLengthDistribution<- function(data){
  VDinst= getVDInsertionLengthDistribution(data)
  stats <- getCoreStats(VDinst)
  plotStats(VDinst,stats,"Histogram of VD Insertion distribution", "VD Insertion Value")
  kbl(stats)
}
DJinsertionLengthDistribution<- function(data){
  DJinst= getDJInsertionLengthDistribution(data)
  stats <- getCoreStats(DJinst)
  plotStats(DJinst,stats,"Histogram of DJ Insertion distribution", "DJ Insertion Value")
  kbl(stats)
}
VJinsertionLengthDistribution<- function(data){
  VJinst= getVJInsertionLengthDistribution(data)
  stats <- getCoreStats(VJinst)
  plotStats(VJinst,stats,"Histogram of VJ Insertion distribution", "VJ Insertion Value")
  kbl(stats)
}

VGene3PrimeDeletionLengthDistribution <- function(data){
  v3prime = getVGene3PrimeDeletionLengthDistribution(data)
  stats <- getCoreStats(v3prime)
  plotStats(v3prime,stats,"Histogram of V Gene 3 prime deletion lengths distribution", "Deletion length Value")
  kbl(stats)
}
VGene5PrimeDeletionLengthDistribution <- function(data){
  v5prime = getVGene5PrimeDeletionLengthDistribution(data)
  stats <- getCoreStats(v5prime)
  plotStats(v5prime,stats,"Histogram of V Gene 5 prime deletion lengths distribution", "Deletion length Value")
  kbl(stats)
}
DGene3PrimeDeletionLengthDistribution <- function(data){
  d3prime = getDGene3PrimeDeletionLengthDistribution(data)
  stats <- getCoreStats(d3prime)
  plotStats(d3prime,stats,"Histogram of D Gene 3 prime deletion lengths distribution", "Deletion length Value")
  kbl(stats)
}
DGene5PrimeDeletionLengthDistribution <- function(data){
  d5prime = getDGene5PrimeDeletionLengthDistribution(data)
  stats <- getCoreStats(d5prime)
  plotStats(d5prime,stats,"Histogram of D Gene 5 prime deletion lengths distribution", "Deletion length Value")
  kbl(stats)
}
JGene3PrimeDeletionLengthDistribution <- function(data){
  j3prime = getJGene3PrimeDeletionLengthDistribution(data)
  stats <- getCoreStats(d3prime)
  plotStats(d3prime,stats,"Histogram of J Gene 3 prime deletion lengths distribution", "Deletion length Value")
  kbl(stats)
}
JGene5PrimeDeletionLengthDistribution <- function(data){
  j5prime = getJGene5PrimeDeletionLengthDistribution(data)
  stats <- getCoreStats(j5prime)
  plotStats(j5prime,stats,"Histogram of J Gene 5 prime deletion lengths distribution", "Deletion length Value")
  kbl(stats)
}
