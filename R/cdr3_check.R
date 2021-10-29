library(Biostrings)
library(data.table)
library(stringr)
library(dplyr)
library(ape)

#'Accesses the CDR3 section of the sequences from a repertoire TSV file.
#'If present it will simply take the CDR3 value ,if it isn't present it will use
#' the junction (Removing flanking codons either side) else it will make use of 
#' the CDR3 start and end values and split the sequence to get the CDR3 seq.
#'@param data Repertoire file in data.table format
#'@return A data.table containing the CDR3 sequence and the row it was taken from in the original repertoire file.
checkCDR3<- function(data){
  
  row_count=0
  seq_ids_vector = vector()
  row_number = vector()
  cdr3_seqs = vector()
  cdr3_start = which(colnames(data)=="cdr3_start") # Gives the column number for cdr3_start
  cdr3_end = which(colnames(data)=="cdr3_end")# Gives the column number for cdr3_end
  junction = which(colnames(data)=="junction")
  rev_comp=which(colnames(data)=="rev_comp")
  cdr3 = which(colnames(data)=="cdr3")
  sequence_id=which(colnames(data)=="sequence_id")
  for(seq in data$sequence){
    row_count = row_count +1
    seq_id = data[row_count,sequence_id,with=FALSE]
    start_num =(data[row_count, cdr3_start,with=FALSE])
    end_num =(data[row_count, cdr3_end,with=FALSE])
    cdr3_val =(data[row_count, cdr3,with=FALSE])
    junction_val = (data[row_count, junction, with=FALSE])
    if(!anyNA(cdr3_val)){
      cdr3_seqs = c(cdr3_seqs,cdr3_val[[1]])
      seq_ids_vector = c(seq_ids_vector,seq_id)
      row_number = c(row_number,row_count)
    }else{
      if(!is.na(junction_val) | junction_val != "" ){
        cdr3_seqs = c(cdr3_seqs,junction_val[[1]])
        row_number = c(row_number,row_count)
        seq_ids_vector = c(seq_ids_vector,seq_id)
      }else{
        if(data[row_count, rev_comp,with=FALSE]=="TRUE" | data[row_count, rev_comp,with=FALSE] =='T'){
          seq=reverseComplement(DNAString(seq))
          cdr3_seqs = c(cdr3_seqs,substr(toString(seq),start_num,end_num)  )
          row_number = c(row_number,row_count)
          seq_ids_vector = c(seq_ids_vector,seq_id)
        }else{
          cdr3_seqs = c(cdr3_seqs,substr(toString(seq),start_num,end_num)) 
          row_number = c(row_number,row_count)
          seq_ids_vector = c(seq_ids_vector,seq_id)
        }
      }
      
      
    } 

  }
 return(cdr3_seq_info <- data.frame(row_number,cdr3_seqs,seqs_ids= seq_ids_vector))}








#'Finds the duplicate CDR3 sequences in the cdr3_seq_info file and returns them.
#'@param cdr3_seq_info data.frame that is returned by the function 'checkCDR3',
#'@param original_data The original data.table variable that contains the whole repetoire file data
#'@param include_ambiguous_calls Boolean value of whether to include ambiguous v_calls in the analysis i.e. "IGHV-30D*1, or 


getVCalls<- function(cdr3_seqs_info,original_data,include_ambiguous_calls){
  joint=vector()
  sequence_id=which(colnames(original_data)=="sequence_id")
  num_occur <- data.frame(table(cdr3_seqs_info$cdr3_seqs))
  duplicates = cdr3_seqs_info[cdr3_seqs_info$cdr3_seqs %in% num_occur$Var1[num_occur$Freq>1],]
  for(seq in unique(duplicates$cdr3_seqs)){
  duplicated_seqs =duplicates[duplicates$cdr3_seqs==seq,]
  v_call_genes = vector()
  related_row=vector()
  gene_matches = array()
  seq_ids  = vector()
    for(row_num in duplicated_seqs$row_number){
      v_call_val = original_data[row_num,"v_call"]
      if(include_ambiguous_calls==FALSE & grepl(",",v_call_val,fixed=TRUE)){
        next
      }else{
      gene_matches <- str_match_all(v_call_val,"^(.*?)\\*| or (.*?)\\*")  
      }
      
      i=2
      
      while(i!=4){
        for(single_match in gene_matches[[1]][,i]){
          if(!is.na(single_match)){
            v_call_genes =c(v_call_genes,single_match)
            related_row =c(related_row,row_num+1) 
            seq_ids = c(seq_ids,original_data[row_num,sequence_id,with=FALSE])
          }
        }
        i=i+1}
      
   
    

    }
  #Below line removes the already sorted sequences so there are no duplicate checks
  #------------------------------------#
  
  if(length(v_call_genes)!=0){
   seq_and_v_call = cbind(seq,v_call_genes,seq_ids)
   joint= rbind(joint,seq_and_v_call)
    
  }
 
  }
  return(as.data.table(joint))
  }

#'The function below takes input of the data table from the function 'getVCalls'
#' and using that and the frequency table it creates plots for a section of them.
#'@param cdr3_data_table table produced from the 'getVCalls' function. Contains data on the sequences and the v-calls associated with them as well as the sequence ID
#'@param num_of_results_to_show the number of results to  plot and display
#'@param aa_or_nn value to determine if the sequences should be displayed as amino acid sequence or nucleotide sequence
#'@param freq_table table containing the number of different v-calls for a given sequence.Used to rule out any sequences that only have one V-call associated with it. 

plotVgeneDist <- function(cdr3_data_table,num_of_results_to_show,aa_or_nn,freq_table){
  seq = vector()
  count = vector()
  
  for(sequence in unique(cdr3_data_table$seq)){
    sequence_data<- cdr3_data_table[cdr3_data_table$seq==sequence,]
    no_row_data=sequence_data[,1:2]
   
    num_of_v_genes = length(unique(no_row_data$v_call_genes))
    seq=c(seq,sequence)
    count = c(count,num_of_v_genes)
   
  }
  
  seq_v_gene_count = data.table(seqs=seq,v_gene_count=count)
  
  seq_v_gene_count = seq_v_gene_count[order(seq_v_gene_count$v_gene_count,decreasing = TRUE),] #Ordered list
  #print(seq_v_gene_count[1:10,])
  
  i=1
  while(i<=num_of_results_to_show & i<=length(seq_v_gene_count$seqs)){
    current_seq=seq_v_gene_count[i,1]
    if(current_seq %in% freq_table$Var1){
    seq_data = cdr3_data_table[cdr3_data_table$seq==current_seq[[1]][1],]
    seq_data=seq_data[,2:3]
    
    writeLines("<hr>")
    writeLines(paste("<h2>Sequence :",current_seq, "</h2>"))
    barplot(table(as.character(seq_data$v_call_genes)),main=paste("Number of occurences of V-gene calls"),las=2)
    
    #cat('\n')
    print(knitr::kable(seq_data))
    #cat('\n')
    
    
    i=i+1  
    }
    
    
  }
  
  
}
