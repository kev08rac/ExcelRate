# Reset button
# first ask the user if they really want to reset their table
observeEvent(
  input$reset,
  {
    showModal(modalDialog(
      title = "Warning",
      paste("Resetting will remove all changes made. ", 
            "Are you sure you would like to do this?", sep = '\n'),
      footer = tagList(
        actionButton(session$ns("confirmReset"), "Yes"),
        modalButton("No")
      )
    ))
  }
)
# If user confirms they want to reset table
observeEvent(input$confirmReset,{
  session$reload()
})