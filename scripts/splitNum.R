splitNum <- function(string, delimiter, wanted) {
  pos_all <- str_locate_all(string, delimiter)[[1]][,'start']
  wanted_pos <- ifelse(wanted > 0, pos_all[wanted], pos_all[length(pos_all) + 1 + wanted])
  
  out <- tibble('first' = substr(string, 1, wanted_pos - 1),
                'second' = substr(string, wanted_pos + 1, nchar(string)))
  
  # if the string has less delimiters than wanted
  if(is.na(out['first']) && is.na(out['second'])) {
    out['first'] <- string
    out['second'] <- NA
  }
  
  return(out)
}
