# File: gdp_map_comparison.R 
# Author: john3kim
# Description: This file is used to upload preprocess the 
# GDP and the R maps data and call the functions in order to 
# Use data from https://data.worldbank.org/indicator/NY.GDP.MKTP.CD?end=2017&start=1960
# TODO: Figure out why Antartica is counted as a country
# Inspired by the reddit post found here: https://www.reddit.com/r/dataisbeautiful/comments/a7mpdh/south_koreas_gdp_per_capita_vs_the_rest_of_the/

library(ggplot2)
library(ggmap)
library(maps)
library(mapdata) 
library(dplyr)
library(tidyr) 
library(purrr)

# Load data and preprocess first
#country_select <- "Brazil"
#GDP_year <- "X2017"
world_data<- map_data("world")

# Transform time series data into a single column representation
GDP_data <- read.csv("GDP_Comparison/data/GDP_data_preprocessed.csv")
years <- c(1960:2017)
years <- paste("X",years,sep="") 

GDP_data <- GDP_data %>% 
  gather(years, key = "year", value ="GDP")

# Preprocess (cont'd): Resolve the cases below:
# Antigua and Barbuda are separate in maps -> Antigua, Barbuda DONE
# Channel Islands become Guernsey and Jersey DONE
# Gibraltar doesn't exist
# Hong Kong resolves into China with region Hong Kong 
# St. Kitts and Nevis resolves to Saint Kitts and Nevis
# Macao SAR, China resolves as China with region Macao
# Trinidad and Tobago resolves into Trinidad, Tobago
# Tuvalu does not exist
# St. Vincent and the Grenadines resolves to Saint Vincent, Grenadines 
# British Virgin Islands resolves to Virgin Islands -> UK 
# Virgin Islands (U.S.) resolves to Virgin Islands -> US

world_data$region[world_data$region == "Antigua"] <- "Antigua and Barbuda"
world_data$region[world_data$region == "Barbuda"] <- "Antigua and Barbuda"
world_data$region[world_data$region == "Jersey"] <- "Channel Islands"
world_data$region[world_data$region == "Guernsey"] <- "Channel Islands"
world_data$region[world_data$region == "China" & world_data$subregion == "Hong Kong"] <- "Hong Kong"
world_data$region[world_data$region == "Saint Kitts"] <- "St. Kitts and Nevis"
world_data$region[world_data$region == "Nevis"] <- "St. Kitts and Nevis"
world_data$region[world_data$region == "China" & world_data$subregion == "Macao"] <- "Macao SAR, China"
world_data$region[world_data$region == "Trinidad"] <- "Trinidad and Tobago"
world_data$region[world_data$region == "Tobago"] <- "Trinidad and Tobago"
world_data$region[world_data$region == "China" & world_data$subregion == "Macao"] <- "Macao SAR, China"
world_data$region[world_data$region == "Virgin Islands" & world_data$subregion == "British"] <- "British Virgin Islands"
world_data$region[world_data$region == "Virgin Islands" & world_data$subregion == "US"] <- "Virgin Islands (U.S.)"

compareGDP <- function(GDP_countries=GDP_data,world=world_data,country="Brazil",GDP_year="2017",type){
  
  country_select <- world %>% filter(region == country)
  GDP_year <- paste("X",GDP_year,sep="")
 
  # Do some comparisons: Select the country to compare 
  
  GDP_selected <- GDP_countries %>% 
    filter(Country.Name == country)%>% 
    filter(year == GDP_year)
  
  # Get only the GDP of a particular country
  GDP_selected <- GDP_selected$GDP 
  
  # We'll have three cases:
  if(type == "greater"){
    # # Countries whose GDP is GDP higher than chosen country
    GDP_compare <- GDP_countries %>%
      filter(GDP > GDP_selected & year == GDP_year)%>%
      select(Country.Name)

    GDP_compare <- world %>%
      filter(world$region %in% GDP_compare$Country.Name)

  }else if (type == "lower-equal"){
    # Countries whose GDP is lower than or equal to Canada
    GDP_compare <- GDP_countries %>%
      filter(GDP <= GDP_selected & year == GDP_year)%>%
      select(Country.Name)

    GDP_compare <- world %>%
      filter(world$region %in% GDP_compare$Country.Name)
  }else if (type == "zero"){
    # No data available
    GDP_compare <- GDP_countries %>%
      filter(is.na(GDP) & year == GDP_year) %>%
      select(Country.Name)

    GDP_compare <- world %>%
      filter(world$region %in% GDP_compare$Country.Name |
               !world$region %in% GDP_countries$Country.Name)
  }else if (type == "select"){
    return(country_select)
  }else{ 
    stop("Choose one of: greater,low-eq,zero")
  }

  return(GDP_compare)
}

# Get a list of all the countries that you can select 
countries_list <- world_data %>% 
                  select(region) %>% 
                  distinct() %>% 
                  arrange(region)

# For test purposes
# country_select <- compareGDP(type="select") 
# GDP_loweq <- compareGDP(type="lower-equal") 
# GDP_higher <- compareGDP(type="greater") 
# GDP_zero <- compareGDP(type="zero") 

# ggplot() +
#   # Lower or equal GDP
#    geom_polygon(data = GDP_loweq, aes(x = long, y = lat,
#                                 group = group),
#                 fill ="orange", color = "blue") +
#   # Higher GDP
#   geom_polygon(data = GDP_higher, aes(x = long, y = lat,
#                                  group = group),
#                fill ="green", color = "blue") +
#   # No data present
#   geom_polygon(data = GDP_zero, aes(x = long, y = lat,
#                                       group = group),
#                fill ="white", color = "blue") +
#   # Country to select
#   geom_polygon(data = country_select, aes(x = long, y = lat,
#                                  group = group),
#                fill ="red", color = "blue") +
#   xlab("Longitude") +
#   ylab("Latitude") +
#   coord_fixed(1.3)
