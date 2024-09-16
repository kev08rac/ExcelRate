# Server functions for downloading tables
output$download <- downloadHandler(
  filename = function() {
    paste0("ExcelRate_",toupper(as.character(format(Sys.Date(),"%d%b%Y"))),"_", as.character(format(Sys.time(),"%H%M")), ".xlsx")
  },
  content = function(file) {
    df <- liveDF()
    df[df == ""] <- NA # for user deleted data - set empty cells to NA
    df[df == " "] <- NA # for user deleted data - set empty cells to NA
    
    write_xlsx(isolate(df), file)
  })