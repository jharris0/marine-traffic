library(shiny)
library(shiny.semantic)
library(leaflet)

ships <- read_csv("data/ships_processed.csv")

ui <- semanticPage(
  title = "Marine Traffic Analytics",
  div(class = "ui grid",
      div(class = "one column row",
          div(class = "ui raised segment",
              style = "margin-top: -15px; padding-top: 18px;",
              h1(class = "ui header",
                 icon("ship"),
                 div(class = "content", "Marine Traffic Analytics")
              )
          )
      ),
      div(class = "one column row",
          leafletOutput("shipmap")
      ),
      div(class = "two column row",
          div(class = "column",
              selectShipTypeUI("selectShipType") # what to put in this label?
          ),
          div(class = "column",
              uiOutput("selectShipName") # what to put in this label?
          )
      ),
      div(class = "two column row",
          div(class = "column",
              textOutput("selected_letter1"),
          ),
          div(class = "column",
              textOutput("selected_letter2")
          )
      )
  )
)

server <- function(input, output, session) {
  
  shipsFiltered <- reactive({
    req(input$ship_name)
    req(input$ship_type)
    ships %>% 
      filter(ship_type == input$ship_type) %>%
      filter(shipname == input$ship_name)
  })
  
  output$selectShipName <- renderUI({
    choice_shipname <- reactive({
      ships %>% 
        filter(ship_type == input$ship_type) %>% 
        pull(shipname) %>%
        as.character()
    })
    dropdown_input(
      input_id = "ship_name",
      choices = choice_shipname()
    )
  })
  
  #selectShipNameServer("selectShipName2") # label?
  
  output$selected_letter1 <- renderText(paste(input$ship_type, collapse = ", "))
  
  output$selected_letter2 <- renderText(paste(input$ship_name, collapse = ", "))
  
  output$shipmap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      )
  })
  
  observeEvent(
    eventExpr = {
      input$ship_name
    },
    handlerExpr = {
      leafletProxy("shipmap", data = shipsFiltered()) %>%
        addMarkers(lng = ~lon,
                   lat = ~lat,
                   label = ~shipname,
                   popup = ~port)
    }
  )
  
  # observeEvent(input$ship_type, {
  #   update_dropdown_input(session, "simple_dropdown", value = "D")
  # })
  # 
  # observeEvent(input$ship_name, {
  #   update_dropdown_input(session, "simple_dropdown", choices = LETTERS, value = input$simple_dropdown)
  # })

}

shinyApp(ui, server)
