library(shiny)
source("GDP_Comparison/data/gdp_map_comparison.R")

fluidPage(
  
  # Application title
  titlePanel(textOutput("title")),
  # Render Map based on the parameters given
  sidebarPanel( 
    sliderInput("yearSelect", "Year to compare:",
                min = 1960, max = 2017,
                value = 2017, sep=""), 
    selectInput("countrySelect", 
                label = "Country to compare with the rest of the world:",
                choices = countries_list,
                selected = "Canada"), 
    HTML("
     <div><strong>Notes:</strong></div> 
     <p>
        The red country denotes the country that you have selected.  Any countries 
        that are orange are those whose GDP value is below or equal to the red country and 
        those in green are those whose GDP values are greater than the red country.
     <p>
    ")
    ),
  mainPanel(
    plotOutput("mapPlot")
  )
)

