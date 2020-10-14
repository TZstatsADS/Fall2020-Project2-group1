#--------------------------------------------------------------------
###############################Install Related Packages #######################
packages.used = as.list(
  c("tidyverse", "shinythemes", "shiny",
    "ggplot2", "shinydashboard",
    "readr", "leaflet", "tigris", "plotly",
    "emojifont", "tigris", "shinyWidgets")
)

check.pkg = function(x){
  if(!require(x, character.only = T)) install.packages(x, character.only=T, dependence=T)
}
lapply(packages.used, require, character.only = TRUE)

#=======================================================================

# read in data file
data_modzcta <- read.csv("../data/coronavirus-data-master/data-by-modzcta.csv")
case_by_boro <- read.csv("../data/coronavirus-data-master/by-boro.csv")
hospitals <- read.csv("../app/output/hospital.csv")
testingcenter <- read.csv("../app/output/testingcenter_geocode.csv")
hotels <- read.csv("../app/output/hotels.csv")
Restaurant <- read.csv("../app/output/Restaurant_cleaned.csv")
center_zipcode <- read.csv("../app/output/center_zipcode.csv")
by_poverty <- read.csv("../data/coronavirus-data-master/by-poverty.csv")
by_race <- read.csv("../data/coronavirus-data-master/by-race.csv")
by_sex <- read.csv("../data/coronavirus-data-master/by-sex.csv")
load('../app/output/covid_zip_code.RData')

#=======================================================================