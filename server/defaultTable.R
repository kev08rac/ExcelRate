# Create an empty excel sheet on app launch
blank_data <- as.data.frame(matrix("", nrow = 100, ncol = 20))
colnames(blank_data) <- LETTERS[1:20]  # Column names from "A" to "T"

# Reactive value to store the data (initially the blank data frame)
values <- reactiveValues(
  data = blank_data
)

# Excel file upload
observeEvent(input$file, {
   req(input$file)
   
   values$data <- read_excel(input$file$datapath)
 })

output$render_table <- renderRHandsontable({ renderCheck(values$data) })
