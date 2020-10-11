#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Define UI for application that draws a histogram



library(shiny)
library(shinythemes)
library(tigris)
library(leaflet)
library(tidyverse)

<<<<<<< HEAD
load("/Users/tianle/Documents/GitHub/Fall2020-Project2-group1/app/output/covid_zip_code.RData")
=======
load("C:/Users/Charlie/Documents/GitHub/Fall2020-Project2-group1/app/output/covid_zip_code.RData")
>>>>>>> 83d725d74c6fe28057af9344dd4aa039f049970a
#setwd("~/")
#load("~/covid_zip_code.RData")


shinyUI(navbarPage(title = 'COVID-19',
                   fluid = TRUE,
                   collapsible = TRUE,
                   #Select whichever theme works for the app 
                   theme = shinytheme("journal"),
                   #--------------------------
                   #tab panel 1 - Home
                   tabPanel("Home",icon = icon("home"),
                            
                            titlePanel("COVID-19 NYC Zip Code Tracker"),
                            
                            
                            titlePanel("Welcome"),
                            
                            HTML("Thank you for using our COVID-19 tracker app! <br />"), 
                            
                            HTML("We understand that in spite of COVID-19, people still must travel to and from New York. 
                            However, practicing social distancing and being aware of recent cases is important. <br />"), 
                            
                            HTML("We are here to help! <br />"), 
                            
                            
                            titlePanel("Who can benefit?"),
                            
                            HTML("<b>Individuals:</b> We hope that this app can help locals and travelers alike in making informed decisons in how they choose to spend their time in here in New York City. 
                                 They are able to select hospitals, hotels, and restuarants based on a zip code of their choice. <br />"),
                            
                            HTML("<b>Local Healthcare Providers:</b> Since our app contains recent cases of COVID-19, local clinics and hospitals can use this information to make predictions about future cases in their areas. <br />"),
                            
                            HTML("<b>Local Newspapers:</b> We also believe that local papers can help keep the public more informed about <i>recent and local</i> cases so that those living in severely affected neighborhoods know to take proper precautions. <br />"),
                            
                            HTML("<b>Local Businesses:</b> Local shops can get a better sense of how COVID-19 is spreading throughout their area so they can change store hours and inventory as needed. 
                                 Mobile store and restaurants, such as food trucks, can also use this app to move and set up shop accordingly. <br />"),
                            
                            titlePanel("How to Use this App"),
                            
                            HTML("It's easy!<br />"), 
                            HTML("1. Click on the Map tab to learn about COVID cases in your area. <br />"), 
                            HTML("2. If you need or want accommodations in a particular zip code or tourist spot, click the Hospitals, Hotels, and Restaurants tabs.  <br />"), 
                            HTML("3. If you would like to learn more about the data, please take a look at the Averages and Sources tabs, where we show both recent and cumulative NYC and Borough averages as well as links to the raw data, respectively."), 
                    
                            titlePanel(
                              img(src='homepic.png', style = 'position:absolute; center'),
                            )
                            
                   ),
                   
                   #--------------------------
                   #tab panel 2 - Map
                   tabPanel("Map", icon = icon("map-marker-alt"),
                            
                            titlePanel("Local NYC COVID-19 Cases"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              
                              sidebarPanel(
                                helpText("Locate an area zip code on the map using the dropdown menu below.", br(), 
                                         "Select up to two zip codes at a time.", br()), 
                                selectInput("ZipCode", 
                                            label = "Zip Code:",
                                            choices = covid_zip_code$GEOID10, selected = 10001, multiple = TRUE),
                                
                                helpText("To see cases near popular tourist attractions, use the following guide.", br(), 
                                         "Central Park: 10019", br(),
                                         "Chinatown: 10002 & 10038", br(),
                                         "Columbia University: 10027", br(),
                                         "Coney Island: 11224", br(),
                                         "Empire State Building: 10001", br(),
                                         "Madison Square Garden: 10010", br(),
                                         "Statue of Liberty: 10004", br(),
                                         "Times Square: 10036", br(), 
                                         "", br()), 
                                
                                helpText("Select what information that should be displayed on the legend.", 
                                         "Colors and scale will adjust according to user selection."), 
                                
                                radioButtons("radio", label = "Legend Information:",
                                             choices = list("COVID Case Count" = "COVID Case Count", 
                                                            "COVID Death Count" = "COVID Death Count", 
                                                            "Total COVID Tests" = "Total COVID Tests", 
                                                            "Positive COVID Tests" = "Positive COVID Tests", 
                                                            "Percent Positive COVID Tests" = "Percent Positive COVID Tests"), 
                                             selected = "COVID Case Count"), 
                                
                                helpText("", br(), 
                                         "Check the box below to display only the most recent COVID-19 cases from the past four weeks.", 
                                         "Most recent 4 week data available: June 21st, 2020 to July 18th, 2020", 
                                         "", br()), 
                                
                                
                                checkboxInput("checkbox", label = "Recent 4 Week Data?", value = FALSE), 
                                
                                helpText("", br(), 
                                         "Note: NYCHealth Open Data Last Updated September 30th, 2020.", 
                                         "", br())
                                
                                
                              ), # end sidebar panel 
                              
                              mainPanel(leafletOutput("myMap", height = 800))
                              
                            ) # end side bar layout
                            
                            
                            
                   ), # end tab 2 panel 
                   
                   
                   
                   
                   #--------------------------
                   #tab panel 3 - Hospitals
                   tabPanel("Hospitals", icon = icon("fas fa-hospital"),
                            
                            titlePanel("NYC Hospital Map"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              
                              sidebarPanel(
                                
                                helpText("Enter or select a zip code to find hospital information in this area.", br()),
                                
                                selectInput("hos_ZipCode", 
                                            label = "Zip Code:",
                                            choices = covid_zip_code$GEOID10, selected = 10001),
                                
                                helpText("Hospital List", br()),
                                
                                tableOutput("hosInfo"),
                                
                                width = 12
                                
                              ), # end sidebar panel
                              
                              mainPanel(leafletOutput("hosMap", height = 600), width = 12)
                              
                            ) # end side bar layout
                            
                            
                            
                   ), # end tab 3 panel 
                   
                   
                   #--------------------------
                   #tab panel 4 - Testing Center
                   tabPanel("Testing Centers", icon = icon("fas fa-hospital"),
                                     
                                     titlePanel("NYC Testing Center Map"),
                                     
                                     # Sidebar with a slider input for number of bins
                                     sidebarLayout(
                                       
                                       sidebarPanel(
                                         
                                         helpText("Enter or select a zip code to find Testing Center information in this area.", br()),
                                         
                                         selectInput("testingcentercode", 
                                                     label = "Zip Code:",
                                                     choices = covid_zip_code$GEOID10, selected = 10001),
                                         
                                         helpText("Testing Center List", br()),
                                         
                                         tableOutput("testingcenterInfo"),
                                         
                                         width = 12
                                         
                                       ), # end sidebar panel
                                       
                                       mainPanel(leafletOutput("testmap", height = 600), width = 12)
                                       
                                     ) # end side bar layout
                                     
                                     
                                     
                   ), # end tab 4 panel 
                   
                   
                   
                   
                   #--------------------------
                   #tab panel 5 - Hotels
                   tabPanel("Hotels", icon = icon("fas fa-hotel"),
                            
                                  titlePanel("NYC Hotel Map"),
                            
                            # Create a new Row in the UI for selectInputs of hotel's zipcode, city, and rate
                            fluidRow(
                              column(4,
                                     selectInput("hotelcode",
                                                 "Zip Code:",
                                                 c("All",
                                                   sort(unique(hotels$postal_code, decreasing=F))))
                              ),
                              column(4,
                                     selectInput("hotelcity",
                                                 "City:",
                                                 c("All",
                                                   unique(as.character(hotels$city))))
                              ),
                              column(4,
                                     selectInput("hotelrate",
                                                 "Rate:",
                                                 c("All",
                                                   sort(unique(hotels$rating),decreasing=T)))
                              )
                            ),
                            # Create a new row for the table of hotel information.
                            DT::dataTableOutput("hotelInfo"),
                            
                            #Adding the map at the bottom of table     
                            mainPanel(leafletOutput("hotelMap", height = 600), width = 12)


                            
                   ), # end tab 5 panel
                   
                   #--------------------------
                   #tab panel 6 - Restaurants
                   tabPanel("Restaurants", icon = icon("fas fa-utensils"),
                            titlePanel("NYC Restaurant Map"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              
                              sidebarPanel(
                                
                                helpText("Enter or select a zip code to find Restaurant information in this area.", br()),
                                
                                selectInput("restaurant_ZipCode", 
                                            label = "Zip Code:",
                                            choices = covid_zip_code$GEOID10, selected = 10025),
                                
                                selectInput("Grade", 
                                            label = "Grade: ",
                                            choices = c("A", "B", "C", "Z", "P"), selected = "C"),
                                
                                helpText("Restaurant List", br()),
                                
                                DT::dataTableOutput("restaurant_Info"),
                                
                                width = 12
                                
                              ), # end sidebar panel
                              
                              mainPanel(leafletOutput("restaurant_Map", height = 600), width = 12)
                              
                            ) # end side bar layout
                            
                            
                   ),
                   
                   #--------------------------
                   #tab panel 7 - Averages
                   tabPanel("Averages", icon = icon("fas fa-table"),
                            
                            titlePanel("NYC Cumulative Average"), 
                            fluidRow(column(12, tableOutput("myTable1"))), 
                            titlePanel("Borough Cumulative Averages"), 
                            fluidRow(column(12, tableOutput("myTable3"))),   
                            titlePanel("NYC Recent Four Week Average"), 
                            fluidRow(column(12, tableOutput("myTable2"))),   
                            titlePanel("Borough Recent Four Week Averages"), 
                            fluidRow(column(12, tableOutput("myTable4"))), # end fluid row
                            
                            HTML("NYCHealth Open Data Last Updated September 30th, 2020."), 
                   ), #end tab 7 panel
                   # ----------------------------------
                   #tab panel 8 - Source
                   tabPanel("Data Source", icon = icon("cloud-download"),
                            HTML(
                              "<h2> Data Source : </h2>
                              <h4> <p><li><a href='https://coronavirus.jhu.edu/map.html'>Coronavirus COVID-19 Global Cases map Johns Hopkins University</a></li></h4>
                              <h4><li>COVID-19 Cases : <a href='https://github.com/CSSEGISandData/COVID-19' target='_blank'>Github Johns Hopkins University</a></li></h4>
                              <h4><li>NYC COVID-19 Data : <a href='https://github.com/nychealth/coronavirus-data' target='_blank'>Github NYC Health</a></li></h4>
                              <h4><li>NYC hospitals Data : <a href='https://opendata.cityofnewyork.us/data/' target='_blank'>NYC Open Data</a></li></h4>
                              <h4><li>Spatial Polygons : <a href='https://www.naturalearthdata.com/downloads/' target='_blank'> Natural Earth</a></li></h4>"
                            ))
))