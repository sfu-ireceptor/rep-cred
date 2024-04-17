#' Get Test Names
#' 
#' This function returns all test files present in the R folder. It doesn't 
#' include any core files. 
#' 
#'
#' @return Vector containing all test names ( file names not including .R) 
#' 
#'

GetTestNames <- function(){
 all_files = GetTestFiles()
  for(i in all_files){
    cleaned_name = gsub('.R','',i)
    cleaned_test_names = c(cleaned_test_names,cleaned_name)
  }
    
return(cleaned_test_names)
}


#' Get Test Files
#' 
#' This function returns all test files present in the R folder. It doesn't 
#' include any core files. 
#' 
#'
#' @return Vector containing all test names ( file names INCLUDING .R) 
#' 
#'

GetTestFiles <- function(){
  all_files = list.files(path="../../R")
  cleaned_test_names <- vector()
  core_files = c("Data.R" , "repcred-core.R" , "repcred.R")
  all_files = setdiff(all_files,core_files)
  return(all_files)
}
