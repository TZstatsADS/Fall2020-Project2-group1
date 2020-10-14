#--------------------------------------------------------------------
###############################Install Related Packages #######################

if (!require("dplyr")) {
  install.packages("dplyr")
  library(dplyr)
}
if (!require("tibble")) {
  install.packages("tibble")
  library(tibble)
}
if (!require("tidyverse")) {
  install.packages("tidyverse")
  library(tidyverse)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}

if (!require("sf")) {
  install.packages("sf")
  library(sf)
}
if (!require("RCurl")) {
  install.packages("RCurl")
  library(RCurl)
}
if (!require("tmap")) {
  install.packages("tmap")
  library(tmap)
}
if (!require("rgdal")) {
  install.packages("rgdal")
  library(rgdal)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}
if (!require("shiny")) {
  install.packages("shiny")
  library(shiny)
}
if (!require("shinythemes")) {
  install.packages("shinythemes")
  library(shinythemes)
}
if (!require("plotly")) {
  install.packages("plotly")
  library(plotly)
}
if (!require("ggplot2")) {
  install.packages("ggplot2")
  library(ggplot2)
}
if (!require("viridis")) {
  install.packages("viridis")
  library(viridis)
}
if (!require("shinydashboard")) {
  install.packages("shinydashboard")
  library(shinydashboard)
}
if (!require("readr")) {
  install.packages("readr")
  library(readr)
}
if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}

if (!require("tigris")) {
  install.packages("tigris")
  library(tigris)
}
if (!require("emojifont")) {
  install.packages("emojifont")
  library(emojifont)
}

if (!require("shinyWidgets")) {
  install.packages("shinyWidgets")
  library(shinyWidgets)
}

#=======================================================================

# read in data file

#data_modzcta <- read.csv("../data/coronavirus-data-master/data-by-modzcta.csv")
#case_by_boro <- read.csv("../data/coronavirus-data-master/by-boro.csv")
#hospitals <- read.csv("../app/output/hospital.csv")
#testingcenter <- read.csv("../app/output/testingcenter_geocode.csv")
#hotels <- read.csv("../app/output/hotels.csv")
#Restaurant <- read.csv("../app/output/Restaurant_cleaned.csv")
#center_zipcode <- read.csv("../app/output/center_zipcode.csv")
#by_poverty <- read.csv("../data/coronavirus-data-master/by-poverty.csv")
#by_race <- read.csv("../data/coronavirus-data-master/by-race.csv")
#by_sex <- read.csv("../data/coronavirus-data-master/by-sex.csv")

load('./output/covid_zip_code.RData')
load('./output/collected_preprocessed_data.RData')


#=======================================================================

# Plot some Pie charts

plot_pie <- plot_ly() %>%
  add_pie(data = by_poverty , labels = ~ POVERTY_GROUP, values = ~CASE_COUNT,
          name = "POVERTY_GROUP",
          title = "POVERTY_GROUP",
          domain = list(row = 0, column = 0))%>%
  add_pie(data = by_race, labels = ~ RACE_GROUP, values = ~CASE_COUNT,
          name = "RACE_GROUP",
          title = "RACE_GROUP",
          domain = list(row = 0, column = 1))%>%
  add_pie(data = by_sex[-3, ] , labels = ~ SEX_GROUP, values = ~CASE_COUNT,
          name = "SEX_GROUP",
          title = "SEX_GROUP",
          domain = list(row = 0, column = 2))%>%  
  
  layout(title = "The Summary of NYC Confirmed Case By Groups", showlegend = F,
         grid=list(rows=1, columns=3),
         paper_bgcolor='transparent',
         xaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE),
         yaxis = list(showgrid = FALSE, zeroline = FALSE, showticklabels = FALSE)
  )
plot_pie 


