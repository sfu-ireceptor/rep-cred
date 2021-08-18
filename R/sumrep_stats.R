#' File that runs a number of sumrep statistics depending on the input conditions
#' 
#' 
#' 

GenomeFileUploaded <- function(){
  
  input <- readLines("/input_data.txt")
  
  if(input == "genome = TRUE"){
    return(TRUE)
  }else if(input == "genome = FALSE"){
    return(FALSE)
  }else{
    return(NULL)
  }
  
}


#' readInStatsData reads in the stats_data.csv file containing the min max values 
#' and other statistical values that are used to determine red and amber values in 
#' repertoires.
#' 
#' *PLEASE NOTE*
#' The stats used were generated from Healthy control sets. If your repertoire has a
#' range of data from people from other areas they may mean the values given
#' are incorrect 
#'
readInStatsData <- function(function_nm){
  stats_data <- read.csv("../../../../../R/stats_data.csv")
  stats_data_row = stats_data[stats_data$function_name==function_nm,]
  return(stats_data)
  
}


CDR3pairwiseDistanceInfo <- function(data){
  
  pairwise_distance = getCDR3PairwiseDistanceDistribution(data)
  
  
  hist(pairwise_distance)
  min_val <- min(pairwise_distance)
  max_val <- max(pairwise_distance)
  quantile_5 <- unname(quantile(pairwise_distance,probs=c(0.05,0.95)))[1]
  quantile_95 <- unname(quantile(pairwise_distance,probs=c(0.05,0.95)))[2]
  ###
  
  stats_data  <- readInStatsData("pairwiseDistanceInfo")
  print(stats_data)
  exp_min <- stats_data[1,2]
  exp_max <- stats_data[1,3]
  
  exp_perc_5 <- stats_data[1,6]
  exp_perc_95 <- stats_data[1,7]
  
  ##
  
  hist(pairwise_distance,main="Histogram of CDR3 pairwise distance" , xlab="CDR3 Pairwise distance")
  abline(v=exp_perc_5,col=" orange")
  abline(v=exp_perc_95,col="orange")
  abline(v=quantile_5,col="blue")
  abline(v=quantile_95,col="blue")
  abline(v=exp_min , col="red")
  abline(v=exp_max , col="red")
  legend("topright",c("Current Rep quantiles","Expected Quantiles","Expected Min and Max"),fill=c("blue","orange","red"))
  
  
}