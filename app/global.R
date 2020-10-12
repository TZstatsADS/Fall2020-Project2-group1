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

setwd("~/Documents/Columbia/2020Fall/Applied Data Science/Project 2/ADS-group-1/data/coronavirus-data-master")


library(tigris)
library(leaflet)

#=======================================================================

# read in data file
data_modzcta <- read.csv("data-by-modzcta.csv")
recent_modzcta <- read.csv("recent/recent-4-week-by-modzcta.csv")
case_by_boro <- read.csv("by-boro.csv")
hospitals <- read.csv("hospital.csv")
testingcenter <- read.csv("testingcenter_geocode.csv")
hotels <- read.csv("hotels.csv")
Restaurant <- read.csv("Restaurant_cleaned.csv")

# drop redundant columns/rows
recent_modzcta_mod <- recent_modzcta[, -1:-2]
case_by_boro <- case_by_boro[1:5,]

# combine data frames
covid_modzcta <- cbind(data_modzcta, recent_modzcta_mod)

# get zip boundaries that start with 1
covid_zip_code <- zctas(cb = TRUE, starts_with = "1")
covid_zip_code <- covid_zip_code[as.numeric(covid_zip_code$ZCTA5CE10) < 11436, ]

covid_modzcta$MODIFIED_ZCTA <- as.character(covid_modzcta$MODIFIED_ZCTA)


# join zip boundaries and covid data 
covid_zip_code <- geo_join(covid_zip_code, 
                           covid_modzcta, 
                           by_sp = "GEOID10", 
                           by_df = "MODIFIED_ZCTA",
                           how = "left")

covid_zip_code <- na.omit(covid_zip_code)

covid_zip_code <- covid_zip_code[order(covid_zip_code$GEOID10), ]

# create two new variables 
covid_zip_code$TOTAL_POSITIVE_TESTS <- floor((covid_zip_code$PERCENT_POSITIVE/100)*covid_zip_code$TOTAL_COVID_TESTS)
covid_zip_code$TOTAL_POSITIVE_TESTS_4WEEK <- floor((covid_zip_code$PERCENT_POSITIVE_4WEEK/100)*covid_zip_code$NUM_PEOP_TEST_4WEEK)

# round off population to nearest whole number 
covid_zip_code$POP_DENOMINATOR <- floor(covid_zip_code$POP_DENOMINATOR)

# add latitude and longitude data to case_by_boro
latitude=c(40.8448,40.6782,40.7831,40.7282,40.5795)
longitude=c(-73.8648,-73.9442,-73.9712,-73.7949,-74.1502)
case_by_boro$Lat=latitude
case_by_boro$Long=longitude
case_by_boro <- 
  case_by_boro%>%
  mutate(region=as.character(BOROUGH_GROUP))

#=======================================================================

setwd("~/Documents/Columbia/2020Fall/Applied Data Science/Project 2/ADS-group-1/app/output")
save(covid_zip_code, file = "covid_zip_code.RData")

#=======================================================================