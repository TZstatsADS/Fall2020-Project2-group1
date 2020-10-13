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

load('../app/output/covid_zip_code.RData')


shinyUI(navbarPage(title = 'Safe Travel in NYC',
                   fluid = TRUE,
                   collapsible = TRUE,
                   #Select whichever theme works for the app 
                   theme = shinytheme("journal"),
                   #--------------------------
                   #tab panel 1 - Home
                   tabPanel("Home",icon = icon("home"),
                            fluidRow(column(tags$img(src="covid.png",width="200px",height="250px"),width=2, align="center"),
                                     column(
                                       
                                       br(),
                                       p(strong("Warning:"),"Travel increases your chance of getting and spreading COVID-19. Staying home is the best way to protect yourself and others from COVID-19.
                                       Dont't travel if you are sick or if you have been around someone with COVID-19 in the past 14 days.",style="text-align:justify;color:black;background-color:yellow;padding:15px;border-radius:10px"),
                                       br(),
                                       
                                       p(strong("Latest Policies in NYC (Last Updated: Sep 30, 2020):"),
                                         HTML("<h5><li>A travel advisory is in effect for individuals traveling to New York from states with significant community spread of COVID-19, requiring a quarantine for 14 days. </li></h5>"), 
                                         HTML("<h5><li>Indoor dining in New York City will be allowed to reopen starting September 30 with a 25 percent occupancy but will be subject to strict safety protocols. </li></h5>"), 
                                         HTML("<h5><li>Governor Cuomo issued Executive Order 205, requiring all travelers coming from states with significant rates of transmission of COVID-19 to quarantine for a 14-day period from the time of their last contact. </li></h5>"),                             
                                         style="text-align:justify;color:black;background-color:orange;padding:15px;border-radius:14px"),
                                       
                                       width=8),
                                     column(
                                       br(),
                                       tags$img(src="nyc.jpg",width="180px",height="230px"),
                                       br(),
                                       br(),
                                       p("For more information please check the New York State official page",
                                         br(),
                                         a(href="https://coronavirus.health.ny.gov/home", "Here",target="_blank"),style="text-align:center;color:black"),
                                       
                                       width=2)),
                            
                            hr(),
                            
                            titlePanel("Welcome"),
                            
                            HTML("Thank you for using our COVID-19 Travel Advisory app. <br />"), 
                            
                            HTML("If you are planning to travel to and from NYC. Our app will provide you information about recent cases and local policies, guide you nearby hospitals and testing centers. In addition, we 
                            have recommendations on hotels and restaurants in safe areas! <br />"), 
                            
                            HTML("We got you covered! Wish you had a safe trip in NYC! <br />"), 
                            
                            titlePanel("Who can benefit?"),
                            
                            HTML("<b>Individuals:</b> We hope that this app can help locals and travelers alike in making informed decisons in how they choose to spend their time in here in New York City. 
                                 They are able to select hospitals, hotels, and restuarants based on a zip code of their choice. <br />"),
                            
                            HTML("<b>Local Healthcare Providers:</b> Since our app contains recent cases of COVID-19, local clinics and hospitals can use this information to make predictions about future cases in their areas. <br />"),
                            
                            HTML("<b>Local Newspapers:</b> We also believe that local papers can help keep the public more informed about <i>recent and local</i> cases so that those living in severely affected neighborhoods know to take proper precautions. <br />"),
                            
                            HTML("<b>Local Businesses:</b> Local shops can get a better sense of how COVID-19 is spreading throughout their area so they can change store hours and inventory as needed. 
                                 Mobile store and restaurants, such as food trucks, can also use this app to move and set up shop accordingly. <br />"),
                            
                            titlePanel("How to Use this App"),
                            
                            HTML("It's easy!<br />"), 
                            HTML("1. Click on the Map tab to learn about COVID cases in your interested areas. <br />"), 
                            HTML("2. If you need or want accommodations in a particular zip code or tourist spot, click the Hospitals, Hotels, and Restaurants tabs.  <br />"), 
                            HTML("3. If you would like to learn more about the data, please take a look at the Averages and Sources tabs, where we show both recent and cumulative NYC and Borough averages as well as links to the raw data, respectively."), 
                            
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
                   #tab panel 3 - Hospitals & Testing Center
                   tabPanel("Hospital & Testing Center", icon = icon("fas fa-hospital"),
                            
                            titlePanel("NYC Hospital/Testing Center Map"),
                            
                            # Sidebar with a slider input for number of bins
                            sidebarLayout(
                              
                              sidebarPanel(
                                
                                radioButtons("choice", label = "", 
                                             choices = list("Hospital Information" = "hos",
                                                            "Testing Center Information" = "test"), inline = TRUE),
                                
                                helpText("Enter or select a zip code to find hospital or testing center information in this area.", br()),
                                
                                selectInput("hos_tc_ZipCode", 
                                            label = "Zip Code:",
                                            choices = covid_zip_code$GEOID10, selected = 10001),
                                
                                helpText("Hospital/Testing Center List", br()),
                                
                                tableOutput("hos_tc_Info"),
                                
                                width = 12
                                
                                
                              ), # end sidebar panel
                              
                              mainPanel(leafletOutput("hos_tc_Map", height = 600), width = 12)
                              
                            ) # end side bar layout
                            
                            
                            
                   ), # end tab 3 panel 
                   
    
                   #--------------------------
                   #tab panel 5 - Hotels
                   tabPanel("Hotel", icon = icon("fas fa-hotel"),
                            titlePanel("NYC Hotel Map"),
                            # Create a new Row in the UI for selectInputs of hotel's zipcode, city, and rate
                            fluidRow(
                              column(4,
                                     selectInput("hotelcode",
                                                 "Zip Code:", 
                                                 choices = sort(unique(hotels$postal_code, decreasing=F)), 
                                                 selected = "10001")
                              ),
                              column(4,
                                     selectInput("hotelcity",
                                                 "City:",
                                                 c("All", unique(as.character(hotels$city))))
                              ),
                              column(4,
                                     selectInput("hotelrate",
                                                 "Rate:",
                                                 choices = sort(unique(hotels$rating), decreasing = T))
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
                                helpText("Enter a zip code and select Grade and Cuisine type to find Restaurant information in this area.", br()),
                                fluidRow(
                                  column(4, selectInput("restaurant_ZipCode", 
                                                        label = "Zip Code:",
                                                        choices = covid_zip_code$GEOID10, selected = 10025)),
                                  column(4, checkboxGroupInput("Grade", "Choose Grade:",
                                                               choices = c("A", "B", "C", "N", "Z"),
                                                               selected = c("C"))),
                                  column(4, checkboxGroupInput("categories", "Choose Categories:",
                                                               choices = c("European", "Asian", "Fast_food", "Seafood", "Vegetarian", "Americas", 
                                                                           "Dessert", "Others", "BBQ", "Oceanian", "Steak", "African"),
                                                               selected = c("European", "Fast_food", "Americas"))),
                                ),
                                helpText("Restaurant List", br()),
                                DT::dataTableOutput("restaurant_Info"), width = 12
                              ), # end sidebar panel
                              mainPanel(leafletOutput("restaurant_Map", height = 600), width = 12),
                            ) # end side bar layout
                   ),
                   
                   #--------------------------
                   #tab panel 7 - Averages
                   tabPanel("Average", icon = icon("fas fa-table"),
                            
                            titlePanel("NYC Cumulative Average"), 
                            fluidRow(column(12, tableOutput("myTable1"))),
                            titlePanel("Borough Cumulative Averages"), 
                            fluidRow(column(12, tableOutput("myTable3"))),
                            titlePanel("Borough Cumulative Barplot - Case"), 
                            fluidRow(column(12, plotOutput("boroplot1"))),
                            titlePanel("Borough Cumulative Barplot - Death"), 
                            fluidRow(column(12, plotOutput("boroplot2"))),
                            titlePanel("NYC Recent Four Week Average"), 
                            fluidRow(column(12, tableOutput("myTable2"))),   
                            titlePanel("Borough Recent Four Week Averages"), 
                            fluidRow(column(12, tableOutput("myTable4"))),
                            titlePanel("Covid Case Count by Poverty Group"), 
                            fluidRow(column(12, plotOutput("boroplot3"))),
                            titlePanel("Covid Case Count by Race Group"), 
                            fluidRow(column(12, plotOutput("boroplot4"))),
                            titlePanel("Covid Case Count by Sex Group"), 
                            fluidRow(column(12, plotOutput("boroplot5"))),# end fluid row
                            
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
                              <h4><li>NYC testing centers Data : <a href='https://www.nychealthandhospitals.org/covid-19-testing-sites/' target='_blank'>NYC Health Hospitals</a></li></h4>
                              <h4><li>Spatial Polygons : <a href='https://www.naturalearthdata.com/downloads/' target='_blank'> Natural Earth</a></li></h4>
                              <h4><li>NYC COVID-19 Policy : <a href='https://coronavirus.health.ny.gov/covid-19-travel-advisory' target='_blank'> New York State Official Website</a></li></h4>"
                            ))
))