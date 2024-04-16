#' @aliases repcred-package
"_PACKAGE"

#' repcred
#'
#' Here we provide an automated tool for repertoire credibility check
#' of adaptive immune receptor repertoire (AIRR) data. 
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
#' @import      shiny
#' @import      rmarkdown
#' @import      knitr
#' @import      bookdown
#' @import      stringi
#' @import      tidyr
#' @import      xfun
#' @import      optparse
#' @importFrom  airr        read_rearrangement write_rearrangement validate_airr
#' @importFrom  ggpubr      theme_pubclean
#' @importFrom  kableExtra  kbl
#' @importFrom  Biostrings  reverseComplement DNAString pairwiseAlignment nucleotideSubstitutionMatrix vcountPattern DNAStringSet
#' @importFrom  knitr       kable 
#' @importFrom  data.table  as.data.table data.table .SD
#' @importFrom  graphics    barplot abline arrows barplot hist
#' @importFrom  stats       na.omit quantile sd start runif
#' @importFrom  utils       head
#' @importFrom  ape         as.DNAbin GC.content
NULL