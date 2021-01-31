selectShipNameUI <- function(id, label = "Ship Name Dropdown") {
  ns <- NS(id)
  uiOutput(ns("ship_name"))
}

# selectShipNameServer <- function(id, data) {
#   moduleServer(
#     id,
#     function(input, output, session) {
#       output$selectShipNameUI <- renderUI({
#         ns <- session$ns
#         dropdown_input(
#           input_id = "ship_name",
#           choices = ships$shipname,
#           value = NULL) 
#       })
#       })
#       
#       # return(reactive({
#       #   validate(need(input$col, FALSE))
#       #   data[,input$col]
#       # }))
#     }
#   )
# }
# 
# selectShipNameServer <- function(id, data) {
#   moduleServer(
#     id,
#     function(input, output, session) {
#       output$selectShipNameUI = renderUI({
#         dropdown_input(
#           input_id = "ship_name",
#           choices = ships$shipname,
#           value = NULL) 
#       })
#     }
#   )
# }
