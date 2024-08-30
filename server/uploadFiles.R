# Server function for uploading files
excelData <- reactive({
  req(input$file)
  read_excel(input$file$datapath)
})

output$render_table <- renderRHandsontable({
  req(excelData())
  rhandsontable(excelData(), stretchH = "all")
})