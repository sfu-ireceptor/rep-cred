library(data.table)

stop_codons = c("TAG","TAA","TGA")

check_for_reverse_compl <- function(file,seq_data){
  seqs_data<- as.data.frame(t(seq_data))
  rev_comp_info <- vector
  row_count = 0
  for(rows in file$rev_comp){
    row_count = row_count+1
    if(row_count %in% seq_data[,2]){
      if(rows == 'T'){
        row_to_change <- which(seq_data[,2] == row_count)
        seq <-(seq_data[row_to_change,1])
        print(reverseComplement(DNAString(seq)))
        
      }
      rev_seq = file[row_count,1]
    }
  }
}

find_stop_codons <- function(sequ){
  for (codon in stop_codons){
   if(grepl(codon,sequ)){
     return(TRUE)
   }else{
     next
   }
  }
  return(FALSE)
}

check_non_coding <- function(file){
  
  row_count=0
  seq <- vector()
  row_val <- vector()
  for(rows in file$productive){
    row_count = row_count+1
    if(rows == 'F'){
      print(row_count)
      print("False")
      seq = c(seq ,file$sequence[row_count])
      row_val = c(row_val , row_count)
    }else{
      print("True")
    }
  }
  seq_and_index <- cbind(seq,row_val)
  return_vals <- c(seq_and_index)
  return(seq_and_index)
}
file <- fread("../../repotoires/ireceptor-public-archive_1.tsv")
seqs <- check_non_coding(file)
check_for_reverse_compl(file,seqs)

find_stop_codons("TTTTTTTTTTTTTTTGA")

