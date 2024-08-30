# Move column
observeEvent(input$moveColGo, {
  df <- liveDF()
  
  # Get user inputs for column to move and the target column
  origCol <- input$moveOrigColName
  moveTo <- input$moveNewColName
  
  # Attempt to move the column to the desired location
  tryCatch({
    df <- df %>% relocate(origCol, .after = moveTo)
  }, error = function(e) {
    print(e)
  })
  
  output$render_table <- renderRHandsontable({ renderCheck(df) })
})

# Rename column
observeEvent(input$renameColNameGo, {
  df <- liveDF()
  
  # Get user inputs for the original column name and the new name
  origCol <- input$renameOrigColName
  newCol <- input$renameNewColName
  
  tryCatch({
    # Check for duplicate column names
    if (tolower(newCol) %in% tolower(names(df))) {
      showModal(modalDialog(
        title = "Error",
        "Column name already exists!",
        easyClose = TRUE
      ))
    } else {
      # Rename the column
      df <- df %>% rename(!!newCol := !!origCol)
    }
  }, error = function(e) {
    print(e)
  })
  
  output$render_table <- renderRHandsontable({ renderCheck(df) })
})

# Add new column
observeEvent(input$addNewColGo, {
  df <- liveDF()
  
  # Get user inputs for new column name and index
  col <- input$addNewColIndex
  colname <- input$addNewColName
  
  tryCatch({
    # Add a new column at the specified index and initialize it with empty strings
    df <- df %>% 
      add_column(colname, .before = col) %>%
      rename(!!colname := "colname") %>%
      replace(colname, " ")
  }, error = function(e) {
    showModal(modalDialog(
      title = "Error",
      paste("Duplicate column names or index out of bounds!", e),
      easyClose = TRUE
    ))
  })
  
  output$render_table <- renderRHandsontable({ renderCheck(df) })
})

# Delete column
observeEvent(input$delColGo, {
  df <- liveDF()
  
  # Get user input for the column to delete
  colName <- input$delColIndex
  
  tryCatch({
    # Delete the specified column
    df <- df %>% select(-colName)
  }, error = function(e) {
    showModal(modalDialog(
      title = "Error",
      e,
      easyClose = TRUE
    ))
  })
  
  output$render_table <- renderRHandsontable({ renderCheck(df) })
})

# Combine columns
observeEvent(input$concatColGo, {
  df <- liveDF()
  
  # Get user inputs for columns to combine and delimiters
  cols <- input$concatCol
  newColName <- input$concatColName
  delims <- strsplit(input$concatColSeps, " ")[[1]]
  
  if (newColName == "") {
    showModal(modalDialog(
      title = "Error",
      "Please create a valid column name.",
      easyClose = TRUE
    ))
  } else if (length(cols) != length(delims) && length(cols) != length(delims) + 1) {
    showModal(modalDialog(
      title = "Error",
      "Please select an appropriate number of separators.",
      easyClose = TRUE
    ))
  } else {
    if (length(cols) == length(delims) + 1) {
      delims[length(cols)] <- ""
    }
    
    # Create a tibble to hold the combined data
    table <- tibble(
      cols = split(df[, cols], seq(nrow(df[, cols]))),
      delims = list(delims)
    ) %>% mutate(cols2 = map(cols, unlist))
    
    # Combine columns using delimiters
    table <- table %>% mutate(!!newColName := map2_chr(cols2, delims, concatCols))
    
    # Replace the existing column if needed
    if (newColName %in% names(df)) {
      df <- df %>% select(-newColName)
    }
    
    # Add the new combined column
    df <- cbind(df, table[, 4])
    
    output$render_table <- renderRHandsontable({ renderCheck(df) })
  }
})

# Split column
observeEvent(input$splitColGo, {
  df <- liveDF()
  
  # Get user inputs for the column to split and delimiter
  col <- input$colNum
  delim <- input$delim
  delimIndex <- input$delimIndex
  names <- c(paste0(col, ".1"), paste0(col, ".2"))
  
  tryCatch({
    if (is.null(df)) {
      showModal(modalDialog(
        title = "Error",
        "No table exists!",
        easyClose = TRUE
      ))
    } else if (delim == "") {
      showModal(modalDialog(
        title = "Error",
        "Please enter a valid delimiter!",
        easyClose = TRUE
      ))
    } else {
      # Split the column into two parts
      tibble <- df %>%
        mutate(data = map(df[, col], splitNum, delimiter = delim, wanted = delimIndex)) %>%
        unnest(data)
      
      # Check if the split was successful
      if (!all(is.na(tibble$second))) {
        # Insert the split columns into the dataframe
        df <- df %>%
          add_column(tibble["first"], tibble["second"], .after = col) %>%
          select(-col) %>%
          rename(!!names[1] := first, !!names[2] := second)
      } else {
        showModal(modalDialog(
          title = "Error",
          "Unable to split column. Please check that your delimiter exists and is in a valid index!",
          easyClose = TRUE
        ))
      }
    }
  }, error = function(e) {
    showModal(modalDialog(
      title = "Error",
      e,
      easyClose = TRUE
    ))
  })
  
  output$render_table <- renderRHandsontable({ renderCheck(df) })
})

output$sessionInfo <- renderPrint({
  sessionInfo()
})