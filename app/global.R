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