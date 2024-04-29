##### rep-cred functions for index.Rmd
#' @include repcred.R
NULL

##########################################################################
# color functions
# repcred-core.R
# Get percentage color
getPercColor <- function(total_num,single_val){
  perc = (single_val/total_num)*100
  color="green"
  if(perc > 25){
    color="red"
  }
  if(perc >10 & perc < 25){
    color="orange"
  }
  return(color)
}

getNormalSeqNumColor <- function(total_num,normal_num){
  perc = (normal_num/total_num)*100
  color="green"
  if(perc<70){
    color="orange"
  }
  if(perc<30){
    color="red"
  }
  return(color)
}



##########################################################################
# Non-nucleotides in sequence
# Check for presence of nucleotides other than ACGT. If found, give statistics and examples
detail_nucleotide <-
  function(non, repertoire, non_nucs, total_pos) {
    occs = str_count(non_nucs, non)
    n_rows = sum(occs != 0)
    n_total = sum(occs)
    perc = round((100 * n_total) / total_pos, digits = 2)
    example_row = head(repertoire[occs != 0, ], 1)
    cat(paste0(
      non,
      ": found in ",
      n_rows,
      " sequence(s). ",
      n_total,
      " in total (",
      perc,
      "%)\n"
    ))
    cat(
      paste0(
        "example sequence id: ",
        example_row$sequence_id,
        "\n",
        example_row$sequence
      )
    )
  }

#' check_nucleotides check the input sequence of AIRR format data for non nucleotides content.
#' In case of non-nucleotide content found, a detail report is printed.
#' 
#' @param repertoire Repertoire data.frame in AIRR format
#' 
#' @return  a list of descriptive statistics of the non-nucliotide characters
#' @export
check_nucleotides <- function(repertoire) {
  non_nucs = str_replace_all(repertoire$sequence, "[ACGTacgt]", "")
  non_nucs = non_nucs[!is.na(non_nucs)]
  all_non = paste0(non_nucs, collapse = "")
  nons = unique(strsplit(all_non, "")[[1]])
  
  if (length(nons) > 0) {
    total_pos = sum(str_length(repertoire$sequence))
    x = lapply(
      nons,
      detail_nucleotide,
      repertoire = repertoire,
      non_nucs = non_nucs,
      total_pos = total_pos
    )
  } else {
    cat("None found.")
  }
}

##########################################################################
# Statistics

findStopCodons <- function(seq) {
  stop_codons = c("TAG", "TAA", "TGA")
  for (codon in stop_codons) {
    if (grepl(codon, seq)) {
      return(TRUE)
    } else{
      next
    }
  }
  return(FALSE)
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
#' a data.frame with the counts of the non-productive categories.
#'
#' @export
fullCheckNonProductiveSeqs <- function(repertoire) {
  idx <- which(!repertoire$productive)
  idx_rev <- which(as.logical(repertoire$rev_comp[idx])==T)
  seq_list <- Biostrings::DNAStringSet(repertoire$sequence_alignment[idx])
  if(length(idx_rev)!=0) seq_list[idx_rev] <- Biostrings::reverseComplement(seq_list[idx_rev])
  seq_frame <- Biostrings::as.data.frame(seq_list)
  names(seq_frame) <- "sequence"
  seq_frame <- seq_frame %>% dplyr::rowwise() %>%
    dplyr::mutate("stop_codons_present" = findStopCodons(!!as.name("sequence")),
                  "non_coding_nucleo_present" = checkNonCodingNucleotides(!!as.name("sequence")),
                  "non_productive_norm" = !(!!as.name("stop_codons_present")) & !(!!as.name("non_coding_nucleo_present"))) %>%
    dplyr::select(-!!as.name("sequence")) %>%
    tidyr::gather(key = "Category", value="Occurences") %>%
    dplyr::group_by(!!as.name("Category")) %>%
    dplyr::summarise("Occurences" = sum(!!as.name("Occurences")))
  return(
    seq_frame
  )
}

###########################################################################################
# repcred-core.R
#' findMissingColumns returns a vector containing the names of columns that contain any
#' NA values.
#'@param data repertoire file in data table format
#'
#'@export
findMissingColumns <- function(data) {
  missing_columns = names(which(sapply(data, anyNA)))
  return(missing_columns)
}

############################################################################################
#' Create the V(D)J gene and allele statistics, counts the frequency of each unique call,
#' number of unique alleles per gene. If a reference set is provided the calls are matched to the 
#' reference and indicated if they were present in the reference.
#'
#' @param repertoire Repertoire dataset in airr format
#' @param reference  A V(D)J germline reference set 
#' @param call       The V(D)J call to summarise
#' 
#' @return 
#' 
#' A list of two dataframes, allele_data contains the information on the allele frequency and
#' gene_data on the gene frequency
#' 
#' @export
getGeneAlleleStat <- function(repertoire, reference = NULL, call="v_call") {
  
  repertoire <- repertoire %>% 
      dplyr::select(!!as.name(call)) %>%
      dplyr::filter(!!as.name(call)!="") %>%
      dplyr::mutate( !!as.name(call) := alakazam::getAllele(!!as.name(call), first=F, collapse=T)) %>%
      dplyr::mutate("allele" =  !!as.name(call)) 
  
  ## get allele-call proportion
  allele_data <- repertoire %>%
    tidyr::separate_rows(!!as.name("allele"), sep = ",") %>%
    dplyr::rowwise() %>%
    dplyr::mutate("proportion" = 1/(stringi::stri_count(!!as.name(call),regex = ",")+1)) %>%
    dplyr::select(!!as.name("allele"),!!as.name("proportion")) %>%
    dplyr::group_by(!!as.name("allele")) %>%
    dplyr::summarise("frequency" = sum(!!as.name("proportion")))
  
  ## get gene-call proportion
  gene_data <- repertoire %>% 
    dplyr::mutate("gene" = alakazam::getGene(!!as.name(call), first = F, collapse = T, 
                                             strip_d = F, omit_nl = F)) %>%
    dplyr::select(!!as.name("gene"), !!as.name(call)) %>%
    dplyr::mutate("proportion" = !!as.name("gene")) %>%
    tidyr::separate_rows(!!as.name("gene"), sep = ",") %>%
    dplyr::rowwise() %>%
    dplyr::mutate("proportion" = 1/(stringi::stri_count(!!as.name("proportion"),regex = ",")+1)) %>%
    dplyr::group_by(!!as.name("gene")) %>%
    dplyr::summarise("frequency" = sum(!!as.name("proportion")),
                     "unique_alleles" = paste0(unique(grep(unique(!!as.name("gene")),unlist(strsplit(!!as.name(call),",")), value = T)), 
                                               collapse = ","),
                     "count_unique_alleles" = stringi::stri_count(!!as.name("unique_alleles"),regex = ",")+1)
  
  if (!is.null(reference)) {
    
    call_region <- substr(gene_data$gene[1],1,4)
    
    alleles <- grep(call_region, names(reference), value=T)
    
    if (length(alleles)!=0) {
      genes <- alakazam::getGene(alleles, first = F, collapse = T, 
                                 strip_d = F, omit_nl = F)
      
      ## check if allele/gene is in ref
      
      allele_data$in_ref <- allele_data$allele %in% alleles
      gene_data$in_ref <- gene_data$gene %in% genes
      allele_data$in_rep <- TRUE
      gene_data$in_rep <- TRUE
      
      if(any(!allele_data$in_ref)){
        print(paste0("The following alleles were not found in the reference set: ", paste0(
          allele_data$allele[!allele_data$in_ref], collapse = ","
        )))
      }
      
      ## add missing alleles and genes for later statistics
      mis_alleles <- alleles[!alleles %in% allele_data$allele]
      mis_gene <- genes[!genes %in% gene_data$gene]
      
      if(length(mis_alleles)!=0) allele_data <- bind_rows(allele_data, data.frame("allele" = mis_alleles,
                                                   "frequency" = 0,
                                                   "in_ref" = TRUE,
                                                   "in_rep" = FALSE))
      if(length(mis_gene)!=0) gene_data <- bind_rows(gene_data, data.frame("gene" = mis_gene,
                                                   "frequency" = 0,
                                                   "in_ref" = TRUE,
                                                   "in_rep" = FALSE))
    }else{
      print(paste0("The reference set supplied does not include alleles from the ", call_region, " call region"))
    }
  }
  
  return(list(allele_data = allele_data,
              gene_data = gene_data))
}
