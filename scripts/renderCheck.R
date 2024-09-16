#Used to check table for rendering.
renderCheck <- function(df) {
  temp <- dim(df)
  
  # if R dataframe object exists
  if (((temp[1] != 0) | (temp[2] != 0)) && ((!is.null(temp[1])) | (!is.null(temp[2])))) {
    rhandsontable(df, 
                  overflow = 'visible', # removes scroll bars that were buggy
                  stretchH = "all",
                  useTypes = FALSE, 
                  rowHeaders = NULL, # prevents confusion since the rownums are the same when copy/pasting
                  manualRowMove = T) %>%
      hot_table(stretchH = "all") %>%
      hot_cols(manualColumnResize = T) %>%
      hot_context_menu(allowColEdit = FALSE, allowRowEdit = TRUE)
  }
}