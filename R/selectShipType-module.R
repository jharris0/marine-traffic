selectShipTypeUI <- function(id, label = "Ship Type Dropdown") {
  # All uses of Shiny input/output IDs in the UI must be namespaced,
  # as in ns("x").
  ns <- NS(id)
  tagList(
    dropdown_input("ship_type", unique(ships$ship_type), 
                   value = 1)
  )
}

exampleModuleServer <- function(id) {
  # moduleServer() wraps a function to create the server component of a
  # module.
  moduleServer(
    id,
    function(input, output, session) {
      count <- reactiveVal(0)
      observeEvent(input$button, {
        count(count() + 1)
      })
      output$out <- renderText({
        count()
      })
      count
    }
  )
}
