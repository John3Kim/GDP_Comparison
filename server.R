library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)
source("data/gdp_map_comparison.R")

world <- map_data("world")


function(input, output) {
  
  output$mapPlot <- renderPlot({
    
    # Use the functions from gdp_map_comparison.R
    year <- input$yearSelect
    country_to_select <- input$countrySelect

    country_select <- compareGDP(country=country_to_select,GDP_year=year,type="select")
    GDP_loweq <- compareGDP(country=country_to_select,GDP_year=year,type="lower-equal")
    GDP_higher <- compareGDP(country=country_to_select,GDP_year=year,type="greater")
    GDP_zero <- compareGDP(country=country_to_select,GDP_year=year,type="zero")


    ggplot() +
      # Lower or equal GDP
      geom_polygon(data = GDP_loweq, aes(x = long, y = lat,
                                         group = group),
                   fill ="orange", color = "blue") +
      # Higher GDP
      geom_polygon(data = GDP_higher, aes(x = long, y = lat,
                                          group = group),
                   fill ="green", color = "blue") +
      # No data present
      geom_polygon(data = GDP_zero, aes(x = long, y = lat,
                                        group = group),
                   fill ="white", color = "blue") +
      # Country to select
      geom_polygon(data = country_select, aes(x = long, y = lat,
                                       group = group),
                   fill ="red", color = "blue") +
      xlab("Longitude") +
      ylab("Latitude") +
      coord_fixed(1.3)

  }) 
  
  output$title <- renderText({paste("GDP Data Comparing",input$countrySelect,
                                    "to the World in",input$yearSelect,"(in $US)",sep=" ")})
}