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
  
  shipsFilteredNames <- reactive({
    req(input$ship_type)
    ships %>%
      filter(ship_type == input$ship_type) %>%
      pull(shipname)
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
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) %>%
      fitBounds(
        lng1 = 11,
        lat1 = 54,
        lng2 = 31,
        lat2 = 60
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
