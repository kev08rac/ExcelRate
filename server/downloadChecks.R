rv <- reactiveValues()
# Outputs text telling the user which columns have missing data in them
rv$missingDataWarn <- reactive({
  df <- liveDF()
  df[df == ""] <- NA
  df[df == " "] <- NA # if the user deletes data manually - set empty strings to NA
  
  tryCatch({
    # get columns with empty data
    missing <- names(which(colSums(is.na(df)) > 0))
    if(length(missing) > 0){
      paste("Missing data in: ", paste(c(missing), collapse = ", "))
    }
  }, error = function(e) {
  })
})
output$missingDataWarn <- renderUI(rv$missingDataWarn())