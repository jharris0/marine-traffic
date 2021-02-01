library(shiny)
library(shiny.semantic)
library(readr)
library(leaflet)

ships <- read_csv("data/ships_processed.csv")

ui <- semanticPage(
  title = "Marine Traffic Analytics",
  div(class = "ui grid",
      div(class = "one column row",
          style = "margin-top: 18px; margin-left: 20px;",
          h1(class = "ui header",
             icon("ship"),
             div(class = "content", "Marine Traffic Analytics")
          )
      ),
      div(class = "one column row",
          leafletOutput("shipmap")
      ),
      div(class = "two column row",
          div(class = "column",
              div(class = "ui pointing below label",
                  p("Select the vessel type")
              ),
              uiOutput("selectShipType")
          ),
          div(class = "column",
              uiOutput("selectShipNameLabel"),
              uiOutput("selectShipName")
          )
      ),
      div(class = "one column row",
          uiOutput("distanceTraveled")
      )
  )
)

server <- function(input, output, session) {

  shipsFilteredNames <- reactive({
    req(input$ship_type)
    ships %>%
      filter(ship_type == input$ship_type) %>%
      pull(shipname)
  })
  
  shipsFiltered <- reactive({
    req(input$ship_type)
    req(input$ship_name)
    ships %>% 
      filter(ship_type == input$ship_type) %>%
      filter(shipname == input$ship_name)
  })
  
  output$selectShipType <- renderUI({
    dropdown_input(
      input_id = "ship_type",
      choices = sort(unique(ships$ship_type))
    )
  })
  
  output$selectShipNameLabel <- renderUI({
    req(input$ship_type)
    div(class = "ui pointing below label",
        p("Select or type the vessel name")
    )
  })
  
  output$selectShipName <- renderUI({
    dropdown_input(
      input_id = "ship_name",
      choices = sort(shipsFilteredNames()),
      type = "search selection"
    )
  })
  
  output$shipmap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$CartoDB.Positron) %>%
      fitBounds(
        lng1 = 11,
        lat1 = 54,
        lng2 = 31,
        lat2 = 60
      )
  })
  
  output$distanceTraveled <- renderUI({
    card(style = "margin-left: 15px;",
         div(class = "content",
             div(class = "header",
                 shipsFiltered()$shipname),
             div(class = "meta",
                 paste("Vessel type:", shipsFiltered()$ship_type)
             ),
             div(class = "description",
                 paste("Distance traveled:", round(shipsFiltered()$dist), "meters"))
         )
    )
  })
  
  observeEvent(
    eventExpr = {
      input$ship_name
    },
    handlerExpr = {
      leafletProxy("shipmap", data = shipsFiltered()) %>%
        clearShapes() %>%
        addPolylines(lng = ~ c(prev_lon, lon),
                     lat = ~ c(prev_lat, lat),
                     color = 'blue',
                     weight = 8)
    }
  )
  
  observeEvent(
    eventExpr = {
      input$ship_name
    },
    handlerExpr = {
      leafletProxy("shipmap", data = shipsFiltered()) %>%
        fitBounds(
          lng1 = ~lon - 0.5,
          lat1 = ~lat - 0.5,
          lng2 = ~lon + 0.5,
          lat2 = ~lat + 0.5
        )
    }
  )
}

shinyApp(ui, server)
