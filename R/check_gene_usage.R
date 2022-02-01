#'@author Georgina Leslie
#'Latest code update: 
#'
#'
library(stringr)
library(data.table)

#''getGeneUsageFrequency' counts the proportional frequency of each gene. 
#'If there are multiple v-calls for a single sequence their value is equal to
#'1/number of genes
#'@param file repertoire file data 
#'
getGeneUsageFrequency <- function(file,gene_table){
  v_call_col = file$v_call
  freq_gene_table <- gene_table
  multiple_gene_freq <- gene_table
  for(v_call in v_call_col){
    if(is.na(v_call)|length(v_call)==0|v_call==""){
      next
    }
     gene_matches <- str_match_all(v_call,"^(.*?)\\*| or (.*?)\\*")
     print(length(gene_matches[[1]]))
     print(gene_matches[[1]])
     if(is.na(gene_matches)|length(gene_matches[[1]])==0){
       next
     }else{
       if(length(gene_matches[[1]]) > 3){
         for(match in gene_matches[[1]]){
           if(is.na(match)){
             next
           }else{
            multiple_gene_freq[multiple_gene_freq$gene_name==match,2] = multiple_gene_freq[multiple_gene_freq$gene_name==match,2]+1
            
           }
           
         }
       }else{
        gene_name <- gene_matches[[1]][1,2]
        print(gene_name)
        freq_gene_table[freq_gene_table$gene_name==gene_name,2] = freq_gene_table[freq_gene_table$gene_name==gene_name,2]+1
     
       }
      
     }
     
    }
  return(list(single_vcall = freq_gene_table , multiple_vcalls = multiple_gene_freq))
  
}

#' geneCount adds the counts from the file to the reference gene set data table.
#' @param gene_list_file contains proportional gene counts from the repertoire file
#' @param gene_list_fasta contains genes from reference genome file
geneCount<- function(gene_list_file,gene_list_fasta){
  freq_gene_table <- gene_list_fasta
  i=1
  while (i<= length(gene_list_file$gene)) {
   gene = gene_list_file$gene[i]
   proportion = gene_list_file$proportion[i]
    freq_gene_table[freq_gene_table$gene_name==gene,2] = freq_gene_table[freq_gene_table$gene_name==gene,2]+proportion
    i=i+1
    }
    
  return(freq_gene_table)
}

#'returns two lists , one with the unique genes present (without the alleles)
#'and one with genes and their alleles)
#'@param gene_freq_list contains the frequency of all genes
#'
getUniqueGenes<-function(gene_freq_list){
  unique_genes_list = data.table()
  gene_allele_link = data.table()
  #unique_genes_list$gene_name <- ""
  #unique_genes_list$allele_count <- 0
  for (row in gene_freq_list$gene_name) {
    removed_allele = str_match(row,"(.*?)\\*")[1,2]
    gene_allele_link = rbind(gene_allele_link,data.table(gene=removed_allele,allele=row))
    if(any(unique_genes_list$gene_name==removed_allele)){
      unique_genes_list[unique_genes_list$gene_name==removed_allele,2]=unique_genes_list[unique_genes_list$gene_name==removed_allele,2]+1
    }else{
      unique_genes_list = rbind(unique_genes_list,data.table(gene_name=removed_allele,allele_count=1))
    }
  }
  return(list(unique_genes_list,gene_allele_link))
}

#'Gets all genes present. Single genes are taken alonw , multi-gene calls are split up 
#'and their proportions are calculated.
#'
#' @export
getGeneData <- function(file){
  gene_data = data.table(gene=character(),proportion=double()) 
  v_call_row = file$v_call
   for(v_call in v_call_row){
    
    #Multi gene-call split
    if(grepl(',',v_call, fixed = TRUE) ){
      split_str <- str_split(v_call,", or ")    
        i=1
        temp_df= data.frame(genes=split_str, proportion = 1/length(split_str[[1]]))
        gene_data = rbind(gene_data,temp_df,use.names=FALSE)
      
        
    #Single gene-call   
    }else{
      temp_df = data.table(gene=v_call,proportion=1)
      gene_data=rbind(gene_data,temp_df)
    }
    
   }
   return(gene_data)
  }

#'Read in the reference genome fasta file , creating a data table with a frequency column
#'containing a starting count of 0
#'@param ref_gene_data fasta file data
readInGeneNamesIMGTFasta <- function(ref_gene_data){
  fasta_file = ref_gene_data
  gene_list = vector()
  for(single_header in names(fasta_file)){
    matches =str_match_all(single_header, "(.*?)\\|")
    gene_list=c(gene_list,matches[[1]][2,2])
  }
  gene_list_table=data.table(gene_name=gene_list)
  gene_list_table$gene_count <-0
  return(gene_list_table)
}

#'Returns a data table containing the data where the frequency is 0
#'@param freq_table frequency table, column 1 is the gene and column 2 is the frequency count
getAbsentGeneList<- function(freq_table){
  deleted_genes <- freq_table[freq_table$gene_count==0,]
  return(deleted_genes)
}
