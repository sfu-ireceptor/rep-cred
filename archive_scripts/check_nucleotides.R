# Include libraries and functions -----------------------------------------------------

#' @include repcred-package.R
NULL

##########################################################################
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


nuc_at = function(seq, pos, filter) {
  if (length(seq) >= pos) {
    if (filter) {
      if (seq[pos] %in% c('N', 'X', '.', '-')) {
        return(NA)
      }
    }
    return(seq[pos])
  } else {
    return(NA)
  }
}


nucs_at = function(seqs, pos, filter) {
  if (filter) {
    ret = data.frame(pos = as.character(c(pos)), nuc = (factor(
      sapply(seqs, nuc_at, pos = pos, filter = filter),
      levels = c('A', 'C', 'G', 'T')
    )))
  } else {
    ret = data.frame(pos = as.character(c(pos)), nuc = (factor(
      sapply(seqs, nuc_at, pos = pos, filter = filter),
      levels = c('A', 'C', 'G', 'T', 'N', 'X', '.', '-')
    )))
  }
  ret = ret[!is.na(ret$nuc), ]
  return(ret)
}

# TODO complete function documentation. Maybe exporting is not needed. We only want to export if we want the user to acces the function.
#' @export
plot_base_composition = function(recs,
                                 title,
                                 pos = 1,
                                 end_pos = 999,
                                 r_justify = F) {
  max_pos = nchar(recs[1])
  
  if (max_pos < pos || length(recs) < 1) {
    return(NA)
  }
  
  max_pos = min(max_pos, end_pos)
  min_pos = max(pos, 1)
  
  if (r_justify) {
    recs = str_pad(recs, max_pos - min_pos + 1, 'left')
  }
  
  recs = strsplit(recs, "")
  
  x = do.call('rbind', lapply(
    seq(min_pos, max_pos),
    nucs_at,
    seqs = recs,
    filter = F
  ))
  
  g = ggplot(data = x, aes_string(x = "pos", fill = "nuc")) +
    scale_fill_brewer(palette = 'Dark2') +
    geom_bar(stat = "count") +
    labs(
      x = 'Position',
      y = 'Count',
      fill = '',
      title = title
    ) +
    theme_classic(base_size = 12) +
    scale_y_continuous(expand = c(0, 0)) +
    theme(axis.text.x = element_blank(), axis.ticks.x = element_blank())
  
  return(g)
}
