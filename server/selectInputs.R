# Stores column names 
col_list <- reactive({
  cols <- colnames(liveDF())
  return(cols)
})

# Gets column names for deleting columns
observe({
  updateSelectizeInput(session,
                       "delColIndex",
                       choices = col_list(),
                       server = TRUE)
})

# Gets column names for combining columns
observe({
  updateSelectizeInput(session,
                       "concatCol",
                       choices = col_list(),
                       server = TRUE)
})

# Gets column names for renaming columns
observe({
  updateSelectizeInput(session,
                       "renameOrigColName",
                       choices = col_list(),
                       server = TRUE)
})

# Gets column names for moving columns - original column
observe({
  updateSelectizeInput(session,
                       "moveOrigColName",
                       choices = col_list(),
                       server = TRUE)
})

# Gets column names for moving columns - move to the right of this column
observe({
  updateSelectizeInput(session,
                       "moveNewColName",
                       choices = col_list(),
                       server = TRUE)
})

# Gets column names for split col selection
observe({
  updateSelectizeInput(session,
                       "colNum",
                       choices = col_list(),
                       server = TRUE)
})