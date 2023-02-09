#' The repcred package
#'
#' The \code{repcred} package provides a repertoire credibility check
#' for adaptive immune receptor repertoire (AIRR) data. 
#'
#'
#' @section  GUI application:
#' The main function of the package upload a GUI application built with shinny. 
#' There the user can upload the AIRR dataset and get a credibility report  
#'
#' \itemize{
#'   \item  \link{repcredWeb}:      Starts the GUI application of repcred credibility check
#' }
#'
#' @name     repcred
#'
#' @import      alakazam
#' @import      ggplot2
#' @import      stringr
#' @import      dplyr
#' @import      sumrep
#' @import      shiny
#' @import      rmarkdown
#' @import      knitr
#' @import      bookdown
#' @import      stringi
#' @import      tidyr
#' @import      xfun
#' @importFrom  airr        read_rearrangement write_rearrangement validate_airr
#' @importFrom  Biostrings  reverseComplement DNAString pairwiseAlignment nucleotideSubstitutionMatrix
#' @importFrom  kableExtra  kbl
#' @importFrom  knitr       kable 
#' @importFrom  data.table  as.data.table data.table .SD
#' @importFrom  graphics    barplot abline arrows barplot hist
#' @importFrom  stats       na.omit quantile sd start runif
#' @importFrom  utils       head
NULL