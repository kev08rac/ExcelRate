# Helper function to create the tibble for combining columns
concatCols <- function(cols, seps){
  rbind(cols, seps) %>% c %>% na.omit %>% paste0(collapse = '')
}