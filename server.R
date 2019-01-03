library(ggplot2)
library(ggmap)
library(maps)
library(mapdata) 

function(input, output) {
  world <- map_data("world")
  
  output$mapPlot <- renderPlot({
    # generate bins based on input$bins from ui.R
    # x    <- faithful[, 2] 
    # bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    # hist(x, breaks = bins, col = 'darkgray', border = 'white')
    ggplot() + 
      geom_polygon(data = world, aes(x = long, y = lat, 
                                         group = group), 
                   fill ="orange", color = "blue") +
      xlab("Longitude") + 
      ylab("Latitude") +
      coord_fixed(1.3)
  })
}