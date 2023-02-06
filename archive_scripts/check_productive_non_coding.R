# library(data.table)
# Include libraries and functions -----------------------------------------------------

#' @include repcred.R
NULL

##########################################################################

stop_codons = c("TAG", "TAA", "TGA")

checkForReverseComplement <- function(file, seq_data) {
  seqs_data <- as.data.table(seq_data)
  row_count = 0
  for (rows in file$rev_comp) {
    row_count = row_count + 1
    if (row_count %in% seqs_data[, 2]) {
      if (rows == 'T' | as.character(rows) == 'TRUE') {
        row_to_change <- which(seqs_data[, 2] == row_count)
        seq <- (seqs_data[row_to_change, 1])
        seqs_data[row_to_change, 1] <-
          reverseComplement(DNAString(seq))
        
      }
    }
  }
  return(seqs_data)
}

findStopCodons <- function(seq) {
  for (codon in stop_codons) {
    if (grepl(codon, seq)) {
      return(TRUE)
    } else{
      next
    }
  }
  return(FALSE)
}

findNonProductiveSeqs <- function(file) {
  row_count = 0
  seq_list <- vector()
  row_val <- vector()
  for (rows in file$productive) {
    row_count = row_count + 1
    if (rows == 'F' | as.character(rows) == 'FALSE') {
      current_seq = file$sequence[row_count]
      seq_list = c(seq_list , current_seq)
      row_val = c(row_val , row_count)
    }
  }
  seq_and_index <- cbind(seq_list, row_val)
  return(seq_and_index)
}

checkNonCodingNucleotides <- function(seq) {
  return(grepl("[^AGTCagtc]", seq))
  
}
#' The categorize the non productive records and returns a detailed statistics
#'
#' @param repertoire Repertoire data.frame in AIRR format
#'
#' @return
#'
#' a list with the counts of the non-productive categories.
#'
#' @export
fullCheckNonProductiveSeqs <- function(repertoire) {
  seqs <-
    findNonProductiveSeqs((repertoire)) #Returns vector containing sequences and their row num if they are non productive
  total_num = length(seqs)
  converted_seqs <- checkForReverseComplement(repertoire, seqs)
  non_productive_ambig = 0
  non_productive_norm = 0
  non_productive_with_stop = 0
  for (sequence in converted_seqs$seq_list) {
    stop_codons_present = findStopCodons(sequence)
    non_coding_nucleo_present = checkNonCodingNucleotides(sequence)
    
    if (non_coding_nucleo_present) {
      non_productive_ambig = non_productive_ambig + 1
    }
    if (stop_codons_present) {
      non_productive_with_stop = non_productive_with_stop + 1
    }
    if (!stop_codons_present & !non_coding_nucleo_present) {
      non_productive_norm = non_productive_norm + 1
    }
    
  }
  return(
    list(
      non_productive_ambig,
      non_productive_with_stop,
      non_productive_norm,
      total_num
    )
  )
}

#' The function tally the productive column of the AIRR format data
#'
#' @param repertoire Repertoire data.frame in AIRR format
#'
#' @return
#'
#' a list with the counts of the productive, non-productive, and un-specified records.
#'
#' @export
getFullRatioNonProductive <- function(repertoire) {
  productive = 0
  non_productive = 0
  na = 0
  for (prod_row in repertoire$productive) {
    switch (
      as.character(prod_row),
      'T' = (productive = productive + 1),
      'F' = (non_productive = non_productive + 1),
      'TRUE' = (productive = productive + 1),
      'FALSE' = (non_productive = non_productive + 1),
      (na = na + 1)
    )
  }
  return(list(
    prod = productive,
    non_prod = non_productive,
    not_specified = na
  ))
}
