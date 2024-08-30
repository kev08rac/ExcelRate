# ExcelRate
# Kevin Anderson
# https://github.com/kev08rac

# this is the library section - SHHHHH!
library(data.table)
library(shiny)
library(shinyjs)
library(tidyverse)
library(htmlwidgets)
library(writexl)
library(rhandsontable)
library(shinydashboard)
library(readxl)
library(shinybusy)
library(shinyWidgets)
library(tibble)
library(DT)

# The UI is used as a menu for the user as well as displaying a table for 
# the sheet the user is working on. The side panel consists of options 
# for creating/editing a table, and the main panel hosts the data table.
ui <- fluidPage(
  shinyjs::useShinyjs(),
  
  # Loading indicator mostly used when files are being read-in
  add_busy_spinner(spin = "fading-circle", position = "full-page", onstart = FALSE),
  
  # Front end style settings
  tagList(tags$head(
    tags$script(type="text/javascript", src = "code.js")),
    tags$style("
               body { font-family: Arial; }
               #tableOptions { text-indent: 20px; }
               #missingDataText { color:red; display: inline; padding-left: 90px; }
               #render_table_comp { white-space: nowrap; }
               ")
    ),
  
  navbarPage(
    title = "ExcelRate", id = "ui_Tabs", theme = shinythemes::shinytheme("readable"),
    tabPanel("Home", value = 1,
             sidebarPanel(width = 3,
                          conditionalPanel(condition = "input.ui_Tabs == 1",
                                          fileInput("file", "Upload Excel file", multiple = TRUE, accept = ".xlsx"),
                                           
                                           fixedRow(id = "tableOptions", HTML("<h5>Table Options</h5>")),
                                           
                                           # Adding/removing columns
                                           fixedRow(
                                             column(1, dropdown(
                                               label = "Add Column", width = 400,
                                               fixedRow(column(10, textInput("addNewColName", "Name of new column"))),
                                               fixedRow(
                                                 column(5, numericInput("addNewColIndex", "Column index", min = 1, value = 1)),
                                                 column(1, actionButton("addNewColGo", "Add column"))
                                               )
                                             )),
                                             column(1, offset = 4, dropdown(
                                               label = "Remove Column", width = 400, 
                                               fixedRow(
                                                 fixedRow(column(10, selectInput("delColIndex", "Column Name", choices = NULL, width = 400))),
                                                 column(1, actionButton("delColGo", "Remove column"))
                                               )
                                             ))
                                           ),
                                           
                                           # Separate by delimiter
                                           fixedRow(
                                             column(1, dropdown(
                                               label = "Split Columns", width = 400,
                                               fixedRow(column(10, selectInput("colNum", "Select Column", choices = NULL, width = 400))),
                                               fixedRow(
                                                 column(6, textInput("delim", "Enter Delim", NA)),
                                                 column(6, numericInput("delimIndex", "Enter Delim Index", value = 1))
                                               ),
                                               fixedRow(column(6, actionButton("splitColGo", "Split Column")))
                                             )),
                                             column(1, offset = 4, dropdown(
                                               label = "Combine Columns", width = 400,
                                               fixedRow(
                                                 column(10, selectizeInput("concatCol", label = "Select columns to combine", choices = NULL, options = list(create = TRUE, maxItems = 100))),
                                                 column(10, textInput("concatColSeps", label = "Type separators in order, with a space between them. For example, '_ - .vcf' will combine 3 selected columns with an underscore, dash, and '.vcf' at the end.")),
                                                 column(10, textInput("concatColName", label = "Enter name of new column"))
                                               ),
                                               fixedRow(column(3, actionButton("concatColGo", label = "Combine Columns")))
                                             ))
                                           ),
                                           
                                           # Move/rename columns
                                           fixedRow(
                                             column(1, dropdown(
                                               label = "Move Column", width = 400,
                                               fixedRow(
                                                 column(10, selectInput("moveOrigColName", "Original Column", choices = NULL)),
                                                 column(10, selectInput("moveNewColName", "Move to the right of this column", choices = NULL)),
                                                 column(10, actionButton("moveColGo", "Move this Column"))
                                               )
                                             )),
                                             column(1, offset = 4, dropdown(
                                               label = "Rename Column", width = 400,
                                               fixedRow(
                                                 column(10, selectInput("renameOrigColName", "Original Column", choices = NULL)),
                                                 column(10, textInput("renameNewColName", "New Column")),
                                                 column(10, actionButton("renameColNameGo", "Rename this Column"))
                                               )
                                             ))
                                           ),
                          )
             ),
             
             mainPanel(
               fixedRow(
                 column(1, actionButton("reset", "Reset Table")),
                 column(1, offset = 10, downloadButton("download", "Download Table")),
                 column(10, offset = 1, id = "missingDataText", uiOutput("missingDataWarn"))
               ),
               
               # Where RHandsontable is displayed
               fixedRow(rHandsontableOutput("render_table"))
             )
    ),
    # New tab for displaying R session info
    tabPanel("Session Info",
             fluidRow(
               column(12,
                      verbatimTextOutput("sessionInfo")
               )
             )
    )
  )
)