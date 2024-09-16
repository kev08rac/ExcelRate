server <- function(input, output, session) {

  # reactive R objs that mimic the tables displayed on the UI  
  liveDF <- reactive({hot_to_r(input$render_table)}) # reactive R object of dataframe

  ### Load helper functions ###
  source(file.path("scripts","renderCheck.R"))
  source(file.path("scripts","splitNum.R"))
  source(file.path("scripts","concateCols.R"))
  
  ### Load server reactives/observes ###
  source(file.path("server","downloadChecks.R"), local = TRUE)$value
  source(file.path("server","downloadFiles.R"), local = TRUE)$value
  source(file.path("server","selectInputs.R"), local = TRUE)$value
  source(file.path("server","resetButton.R"), local = TRUE)$value
  source(file.path("server","columnFunctions.R"), local = TRUE)$value
  source(file.path("server","defaultTable.R"), local = TRUE)$value
}