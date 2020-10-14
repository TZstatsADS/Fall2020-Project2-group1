#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# Define UI for application that draws a histogram


dashboardPage(
  skin = "yellow",
  dashboardHeader(title = "Safe Travel in NYC"),
  dashboardSidebar(sidebarMenu(
    menuItem("Home", tabName = "Home", icon = icon("home")),
    menuItem("Our Map", tabName = "Our Map", icon = icon("fas fa-globe"), startExpanded = TRUE,
             menuSubItem("ZipCodeTracker", tabName = "ZipCodeTracker", icon = icon("fas fa-map-signs")),
             
             menuSubItem("Hospitals&TestingCenters", tabName = "HospitalsTestingCenters", icon = icon("fas fa-hospital")),
             
             menuSubItem("Hotels",tabName = "Hotels",icon = icon("fas fa-hotel")),
             
             menuSubItem("Restaurants",tabName = "Restaurants",icon = icon("fas fa-coffee"))   

    ),
    menuItem("Averages", tabName = "Averages", icon = icon("fas fa-table")),
    menuItem("About", tabName = "About", icon = icon("fas fa-asterisk"))
  )
  ),
  
  dashboardBody(fill = FALSE,tabItems(
    # Tab panel 1 Home -------------------------------------------------------------------------------------------------------
    tabItem(tabName = "Home",
            #fluidRow(), 
            
            fluidRow(column(width = 3,img(src="covid.png",width = "100%", height = "35%"),align = "left",
                            p(strong("NOTICE:"),"all out-of-state travelers from designated states must complete the form upon entering New York.",
                              br(),
                              a(href="https://coronavirus.health.ny.gov/covid-19-travel-advisory", "COMPLETE THE ONLINE TRAVELER HEALTH FORM",target="_blank"),style="text-align:center;color:black")),
                     box(width = 6, height = "20%", h2(strong("Welcome"),align = "center"),
                         background = "yellow",solidHeader = TRUE,
                         h3(hr()),
                         h3("Thank you for using our COVID-19 Travel Advisory app."),
                         h3("If you are planning to travel to and from NYC. Our app will provide you information about recent cases and local policies, guide you nearby hospitals and testing centers. In addition, we have recommendations on hotels and restaurants in safe areas! "),
                         h3("We got you covered! Wish you had a safe trip in NYC! ")),
                     column(width = 3,img(src="nyc.jpg",width = "100%", height = "35%"),align = "right", 
                            p("For more information please check the New York State official page",
                              br(),
                              a(href="https://coronavirus.health.ny.gov/home", "Here",target="_blank"),style="text-align:center;color:black")),
            ),
            hr(),
            fluidRow(
              column(12, fluidPage(includeMarkdown("./output/warning.md")))
            ),
            fluidRow(
              
              column(4, fluidPage(includeMarkdown("./output/latest.md"))),
              
              column(4, fluidPage(includeMarkdown("./output/how.md"))),
              
              column(4, fluidPage(includeMarkdown("./output/who.md")))
            )
            
    ),
    # Tab panel 2 MAP-------------------------------------------------------------------
    #sub1 ------------------------------------------------------------------------------
    tabItem(tabName = "ZipCodeTracker",
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
    ),
    
    # Tab panel 2 MAP Hospitals & Testing Center -------------------------------------
    #sub2 ----------------------------------------------------------------------------
    tabItem(tabName = "HospitalsTestingCenters",
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
                            choices = covid_zip_code$GEOID10, selected = 10002),
                helpText("Hospital/Testing Center List", br()),
                tableOutput("hos_tc_Info"),
                width = 12
              ), # end sidebar panel
              mainPanel(leafletOutput("hos_tc_Map", height = 600), width = 12)
            ) # end side bar layout
    ), # end tab 2 - Hospital panel 
    
    
    # Tab panel 2 MAP Hotel ----------------------------------------------------------
    #sub3 ----------------------------------------------------------------------------
    tabItem(tabName = "Hotels",
            titlePanel("NYC Hotel Map"),
            # Create a new Row in the UI for selectInputs of hotel's zipcode, city, and rate
            helpText("Select Zipcode or Neighborhood ('city')", br()),
            fluidRow(
              column(4, selectInput("hotelcode",
                                 "Zip Code:", 
                                 choices = sort(unique(hotels$postal_code, decreasing=F)), 
                                 selected = "10001")),
              column(4, selectInput("hotelcity",
                                 "Neighborhood ('city'):",
                                 c("All", unique(as.character(hotels$city))))),
              column(4, selectInput("hotelrate",
                                 "Rating:",
                                 choices = c('All',sort(unique(hotels$rating), decreasing = T))))
            ),
            
            # Create a new row for the table of hotel information.
            DT::dataTableOutput("hotelInfo"),
            
            #Adding the map at the bottom of table     
            mainPanel(leafletOutput("hotelMap", height = 600), width = 12)
            
    ), # end tab 2 Hotel
   

    # Tab panel 2 MAP Restaurants ----------------------------------------------------
    #sub4 ----------------------------------------------------------------------------
    tabItem(tabName = "Restaurants",
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
                                               selected = c("A", "B","C"))),
                  column(4, checkboxGroupInput("categories", "Choose Categories:",
                                               choices = c("European", "Asian", "Fast_food", "Seafood", "Vegetarian", "Americas", 
                                                           "Dessert", "Others", "BBQ", "Oceanian", "Steak", "African"),
                                               selected = c("European", "Fast_food", "Americas"))),
                ),
                fluidRow(
                  column(4, checkboxGroupButtons("Alcohol_NoAlcohol", "Choose Alcohol/No Alcohol:", choices = c("yes","no"), selected = "no")),
                  column(4, checkboxGroupButtons("Roadway_Seating", "Choose Roadway Seating/No Roadway Seating:", choices = c("yes","no"), selected = "yes")),
                  column(4, checkboxGroupButtons("Sidewalk_Seating", "Choose Sidewalk Seating/No Sidewalk Seating:", choices = c("yes","no"), selected = "yes")),
                ),
                helpText("Restaurant List", br()),
                DT::dataTableOutput("restaurant_Info"), width = 12
              ), # end sidebar panel
              mainPanel(leafletOutput("restaurant_Map", height = 600), width = 12),
            ) # end side bar layout
    ),
    # Tab panel 3  Averages----------------------------------------------------------------
    tabItem(tabName = "Averages",
            
            titlePanel("NYC Cumulative Average"), 
            fluidRow(column(12, tableOutput("myTable1"))),
            titlePanel("Borough Cumulative Averages"), 
            fluidRow(column(12, tableOutput("myTable3"))),
            titlePanel("NYC Recent Four Week Average"), 
            fluidRow(column(12, tableOutput("myTable2"))),
            titlePanel("Borough Recent Four Week Averages"), 
            fluidRow(column(12, tableOutput("myTable4"))),
            
            titlePanel("The Summary of NYC Confirmed Case by Groups"),
            fluidRow(column(12, plotlyOutput("Pie_chart"))),
            titlePanel("The Summary of Case Averages in NYC by Borough"),
            fluidRow(column(4, title = "Borough Cumulative - Confirmed Case Averages", plotOutput("boroplot1")),
                     column(4, title = "Borough Cumulative - Death Case Averages", plotOutput("boroplot2")),
                     column(4, title = "Borough Cumulative - Positive rate", plotOutput("boroplot3"))),

            
            HTML("NYCHealth Open Data Last Updated September 30th, 2020."), 
    ), 
    
    # Tab panel 4  Data Source-------------------------------------------------------------
    tabItem(tabName = "About", 
            HTML(
              "<h2> Data Source : </h2>
                              <h4> <p><li><a href='https://coronavirus.jhu.edu/map.html'>Coronavirus COVID-19 Global Cases map Johns Hopkins University</a></li></h4>
                              <h4><li>COVID-19 Cases : <a href='https://github.com/CSSEGISandData/COVID-19' target='_blank'>Github Johns Hopkins University</a></li></h4>
                              <h4><li>NYC COVID-19 Data : <a href='https://github.com/nychealth/coronavirus-data' target='_blank'>Github NYC Health</a></li></h4>
                              <h4><li>NYC COVID-19 Policy : <a href='https://coronavirus.health.ny.gov/covid-19-travel-advisory' target='_blank'> New York State Official Website</a></li></h4>
                              <h4><li>NYC Hospital Data : <a href='https://opendata.cityofnewyork.us/data/' target='_blank'>NYC Open Data</a></li></h4>
                              <h4><li>NYC Restaruant Data : <a href='https://data.cityofnewyork.us/Transportation/Open-Restaurant-Applications/pitm-atqc' target='_blank'>NYC Open Data</a></li></h4>
                              <h4><li>NYC Testing Center Data : <a href='https://www.nychealthandhospitals.org/covid-19-testing-sites/' target='_blank'>NYC Health + Hospitals</a></li></h4>
                              <h4><li>Spatial Polygons : <a href='https://www.naturalearthdata.com/downloads/' target='_blank'> Natural Earth</a></li></h4>"
              
            ),
            
            titlePanel("Disclaimers : "),
            HTML(
              "<b>COVID-19 Guideslines : </b> <br>
                              <li>Our goal is to provide general guidelines for the public to consider as they navigate NYC and to inform the public of openly available data. </li>
                              <li>This is no way constitutes as professional medical advice. </li>
                              <li>Please talk to your doctor or healthcare provider if you have any questions or concerns about COVID-19.</li>" 
            ),
            
            HTML(
              "<b>NYC Health OpenData : </b> <br>
                              <li>The COVID-19 data is an observational study and any inferences drawn from this map should be treated with caution. </li>
                              <li>The data shown here only reflects the currently situation in NYC, and thus, is not representative of the entire United States as a whole.</li>
                              <li>Data about COVID-19 is always continuously updated but the data here is only a snapshot of something that is continuously changing.</li>" 
            ),
            
            HTML(
              "<b>NYC Hotel Data : </b> <br>
                              <li>Room rates were updated in 2017, but hotel information keeps changing, especially during the outbreak. Please visit their official website to obtain the latest information. </li>"
            ),
            
            HTML(
              "<b>NYC Hospital Data : </b> <br>
                              <li>The data only contains facilities from the NYC Health + Hospitals health care system. </li>
                              <li>The data was updated on July 3, 2019, so some information may have changed. </li>"
            ),
            
            HTML(
              "<b>NYC Restaurant Data : </b> <br>
                              <li> Department of Health and Mental Hygiene (DOHMH) New York City Restaurant Inspection Results is a data contains NYC restaurant inspection results for up to three years prior to the most recent inspection. </li>
                              <li> Open Restaurant Applications is a dataset of applications from food service establishments seeking authorization to re-open under Phase Two of the State’s New York Forward Plan and place outdoor seating in front of their business on the sidewalk and/or roadway. </li>"
            ),
            
            HTML(
              "<b>NYC Testing Center Data : </b> <br>
                              <li>The data only contains the most resent testing centers from NYC health hospitals website. </li>
                              <li>Some testing centers are mobile, please go to the NYC health hospitals website to check the updated exact addresses for the testing centers. </li>"
            ),
            
            titlePanel("Credits : "),
            HTML(
              " <p>This website was built using RShiny.</p>",
              "<p>The following R packages were used in to build this RShiny application:</p>
                                <p>
                                <code>base</code><code>dplyr</code><code>tibble</code>
                                <code>leaflet</code><code>tidyverse</code><code>shinythemes</code>
                                <code>padr</code><code>plotly</code><code>ggplot2</code>
                                <code>tigris</code><code>shiny</code><code>shinydashboard</code><code>sp</code><code>stringr</code>
                                <code>tidyr</code>
                                </p>
                                <p>This website is the result of 2020Fall GR5243 Project2 Group1, Class of 2020 of the M.A. Statistics program at Columbia University.</p>",
              " <p>Chen, Zhenglei    |email: zc2494@columbia.edu </p>",
              " <p>Lee, Levi         |email: ll3248@columbia.edu </p>",
              " <p>Peng, Xinyuan     |email: xp2177@columbia.edu </p>",
              " <p>Tong, Yuwei       |email: yt2713@columbia.edu </p>",
              " <p>Zhu, Tianle       |email: tz2434@columbia.edu </p>"
            )
    )
  )
 )
)
  
  