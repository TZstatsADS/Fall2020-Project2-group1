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

setwd("../data/coronavirus-data-master")

library(tigris)
library(leaflet)

#=======================================================================

# read in data file
data_modzcta <- read.csv("data-by-modzcta.csv")
recent_modzcta <- read.csv("recent/recent-4-week-by-modzcta.csv")

# drop redundant columns 
recent_modzcta_mod <- recent_modzcta[, -1:-2]

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

#=======================================================================

setwd("../app/output")
save(covid_zip_code, file = "covid_zip_code.RData")

#=======================================================================

