library(shiny)
fluidPage(
  
  # Application title
  titlePanel("GDP Data Comparing the World"),
  mainPanel(
    plotOutput("mapPlot")
  )
)

