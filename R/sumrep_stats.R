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


pairwiseDistanceInfo <- function(file_data_table){
  
  pairwise_distance = getPairwiseDistanceDistribution()
  
  hist(pairwise_distance)
  min(pairwise_distance)
  max(pairwise_distance)
  
  
  
}