#'@author Georgina Leslie
library(data.table)
library(seqinr)
library(stringr)
library(Biostrings)
library(spgs)
library(ggplot2)

#'getNumAmbiguousSeqs returns a list of two values. First the number of sequences 
#'containing ambiguous calls, second the number of normal sequences
#'@param data repertoire file in data table format
getNumAmbiguousSeqs <- function(data){
ambiguous_calls = 0
normal_seqs = 0
for (seq in data$sequence) {
    if(grepl("[^AGTC]",seq)){
    ambiguous_calls = ambiguous_calls+1
    }else{
      normal_seqs=normal_seqs+1
    }
 
}
   return(list(ambiguous_calls,normal_seqs))
}

#'getSeqLengths returns the number of characters in each nucleotide sequence in the 
#'repertoire
#'@param data repertoire file in data table format
getSequenceLengths <- function(data){
  sequence_lengths <- vector(length=length(data$sequence))
  i=0
  for(seq in data$sequence){
    sequence_lengths[i] = nchar(seq)
    i=i+1
  }
    return(sequence_lengths)
}

#' A function that displays the coverage of a sequence to its gene
#' PLEASE NOTE. This function is NOT implemented into the  
#' @param file_data the repertoire file data 
#' @param gene_list the list of genes 
getSequenceCoverage <- function(file_data , gene_list){
  row = 1
 gene_list_names = names(gene_list)
  for(v_call in file_data$v_call){
    #print(v_call)
    gene_matches <- str_match_all(v_call,"^(.*?),| or (.*?),| or (.*?)$|^(.*?)$")
    i=2
    v_call_genes = vector()
    while(i!=6){
      for(single_match in gene_matches[[1]][,i]){
        if(!is.na(single_match)){
          v_call_genes =c(v_call_genes,single_match)
        }
      }
      i=i+1
    }
    
    for (gene in v_call_genes) {
      print("here")
      for(name in gene_list_names){
        matches =str_match_all(name, "(.*?)\\|")
        gene_name=matches[[1]][2,2]
        if(gene_name == gene){
          print("---------")
          print(name)
          row_count=row
          print(gene_list[[name]][1])
          if(file_data[row_count,3]=="T"){
            seq = toString((file_data[row_count,1]))
            print(reverseComplement(DNAString(seq)))
            print(gene_list[[name]][1])
            print(alignSequenceToKnownGeneSeq(reverseComplement(DNAString(seq)),gene_list[[name]][1]))
          }
          print("---------")
        }
      }
    }
  
  row=row+1 
}
}

alignSequenceToKnownGeneSeq <- function(data_seq,gene_seq){
  print(data_seq)
  print(gene_seq)
  sub_mat <- nucleotideSubstitutionMatrix(match = 1, mismatch = -2, baseOnly = TRUE)
  global = pairwiseAlignment(DNAString(data_seq),DNAString(gene_seq),substitutionMatrix = sub_mat , gapOpening=2,gapExtension=1 )
  local = pairwiseAlignment(DNAString(data_seq),DNAString(gene_seq),type="local", substitutionMatrix = sub_mat , gapOpening=2,gapExtension=1 )
  print(global)
  print(local)
  
  
  return(plotSequenceAlignments(local,data_seq,gene_seq))
}


plotSequenceAlignments<-function(alignment_object,data_seq,gene_seq){
  
  data_align_start=as.integer(alignment_object@subject@range@start)
  data_align_end = as.integer(data_align_start + alignment_object@subject@range@width)
  gene_align_start=as.integer(alignment_object@pattern@range@start)
  gene_align_end =as.integer( gene_align_start + alignment_object@pattern@range@width)

  data=data.frame(sequence = c(1,1,1,2,2,2) ,
                  start = c(1,data_align_start,data_align_end+1,1,gene_align_start,gene_align_end+1),
                  end = c(data_align_start-1,data_align_end,nchar(gene_seq),gene_align_start-1,gene_align_end,length(data_seq)),
                  type= c("non-aligned","aligned","non-aligned","non-aligned","aligned","non-aligned"))

  ggplot(data=data, mapping=aes(ymin=0, ymax=1, xmin=start, xmax=nchar(gene_seq), fill=type)) +
    geom_rect() + facet_grid(sequence~., switch="y") +
    labs(x="Position", y="Sequence", title="Mapped regions for all sequences") +
    theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
    theme(plot.title = element_text(hjust = 0.5))
  
  dat <- data.frame(sequence=c(1,2,2,2), start=c(1,1,2001,8000), stop=c(9000,2000,7999,9000), type=c("mapped","mapped","deletion","mapped"))
  
  ggplot(data=dat, mapping=aes(ymin=0, ymax=1, xmin=start, xmax=stop, fill=type)) +
    geom_rect() + facet_grid(sequence~., switch="y") +
    labs(x="Position (BP)", y="Sequence / Strain", title="Mapped regions for all sequences") +
    theme(axis.text.y=element_blank(), axis.ticks.y=element_blank()) +
    theme(plot.title = element_text(hjust = 0.5))
  
}

#' findMissingColumns returns a vector containing the names of columns that contain any
#' NA values.
#'@param data repertoire file in data table format
findMissingColumns<- function(data){
  missing_columns = names(which(sapply(data,anyNA)))
  return(missing_columns)
}

