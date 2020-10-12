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
if (!require("emojifont")) {
  install.packages("emojifont")
  library(emojifont)
}

#--------------------------------------------------------------------

if (!require("tigris")) {
  install.packages("tigris")
  library(tigris)
}


if (!require("leaflet")) {
  install.packages("leaflet")
  library(leaflet)
}

#=======================================================================

#setwd("~/Documents/Columbia/2020Fall/Applied Data Science/Project 2/ADS-group-1/data/coronavirus-data-master")
#setwd("../data/coronavirus-data-master")
library(tigris)
library(leaflet)
library(readr)

#=======================================================================

# read in data file
data_modzcta <- read.csv("../data/coronavirus-data-master/data-by-modzcta.csv")
case_by_boro <- read.csv("../data/coronavirus-data-master/by-boro.csv")
hospitals <- read.csv("../data/hospital.csv")
testingcenter <- read.csv("../data/testingcenter_geocode.csv")
hotels <- read.csv("../data/hotels.csv")
Restaurant <- read.csv("../data/Restaurant_cleaned.csv")
center_zipcode <- read.csv("../data/center_zipcode.csv")
load('../data/covid_zip_code.RData')

#=======================================================================