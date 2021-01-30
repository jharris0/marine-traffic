library(shiny)
library(shiny.semantic)
#library(semantic.dashboard)
library(leaflet)

library(geosphere)
library(readr)
library(tidyr)
library(dtplyr)
library(dplyr, warn.conflicts = F)

ships <- read_csv("data/ships_processed.csv")

ui <- semanticPage(
  title = "Marine Traffic Analyzer",
  div(class = "ui raised segment",
      div(
        leafletOutput("shipmap"),
        a(class="ui green ribbon label", "Link"),
        p("Lorem ipsum, lorem ipsum, lorem ipsum"),
        actionButton("button", "Click")
      )
  )
)

server <- function(input, output) {
  
  output$shipmap <- renderLeaflet({
    leaflet() %>%
      addProviderTiles(providers$Stamen.TonerLite,
                       options = providerTileOptions(noWrap = TRUE)
      ) #%>%
      #addMarkers(data = points())

})
}

shinyApp(ui, server)
