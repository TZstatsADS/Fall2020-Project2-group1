#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
#-------------------------------------------------App Server----------------------------------

library(shiny)
library(shinythemes)
library(tigris)
library(leaflet)
library(tidyverse)


#can run RData directly to get the necessary date for the app
#global.r will enable us to get new data everyday
#update data with automated script


load("C:/Users/Charlie/Documents/GitHub/Fall2020-Project2-group1/app/output/covid_zip_code.RData")
#setwd("~/")
#load("~/covid_zip_code.RData")


shinyServer(function(input, output) {
    #----------------------------------------
    #tab panel 1 - COVID Zip Code Tracker
    
    
    
    #----------------------------------------
    #tab panel 2 - Maps
    
    output$myMap <- renderLeaflet({
        
        # this determines the chosen parameter the user has selected 
        # did the user want recent or cumulative data?
        # what information did the user want to see in the legend?
        # see "add a legend" and 'create color palette' comment below to see chosen_parameter variable in use
        chosen_parameter <- if (input$radio == "COVID Case Count") {
            if(input$checkbox == TRUE){covid_zip_code$COVID_CASE_COUNT_4WEEK} else{covid_zip_code$COVID_CASE_COUNT}
        } else if (input$radio == "COVID Death Count") {
            if(input$checkbox == TRUE){covid_zip_code$COVID_DEATH_COUNT_4WEEK} else{covid_zip_code$COVID_DEATH_COUNT}
        } else if (input$radio == "Total COVID Tests") {
            if(input$checkbox == TRUE){covid_zip_code$NUM_PEOP_TEST_4WEEK} else{covid_zip_code$TOTAL_COVID_TESTS}
        } else if (input$radio == "Positive COVID Tests") {
            if(input$checkbox == TRUE){covid_zip_code$TOTAL_POSITIVE_TESTS_4WEEK} else{covid_zip_code$TOTAL_POSITIVE_TESTS}
        } else if (input$radio == "Percent Positive COVID Tests") {
            if(input$checkbox == TRUE){covid_zip_code$PERCENT_POSITIVE_4WEEK} else{covid_zip_code$PERCENT_POSITIVE}
        }
        
        
        
        # create color palette 
        pal <- colorNumeric(
            palette = "Greens",
            domain = chosen_parameter)
        
        # create labels for zipcodes
        labels <-  paste0(
            "Zip Code: ", covid_zip_code$GEOID10, "<br/>",
            "Neighborhood: ", covid_zip_code$NEIGHBORHOOD_NAME, "<br/>",
            "Borough: ", covid_zip_code$BOROUGH_GROUP, "<br/>",
            "Population Denominator (Estimate): ", floor(covid_zip_code$POP_DENOMINATOR), "<br/>",
            
            # this number change depending on the options the user has selected
            # did the user want recent or cumulative data?
            # seperate check from the chosen_parameter variable above 
            "COVID Case Count: ", if(input$checkbox == TRUE){covid_zip_code$COVID_CASE_COUNT_4WEEK} else{covid_zip_code$COVID_CASE_COUNT}, "<br/>",
            "COVID Death Count: ", if(input$checkbox == TRUE){covid_zip_code$COVID_DEATH_COUNT_4WEEK} else{covid_zip_code$COVID_DEATH_COUNT}, "<br/>",
            "Total COVID Tests: ", if(input$checkbox == TRUE){covid_zip_code$NUM_PEOP_TEST_4WEEK} else{covid_zip_code$TOTAL_COVID_TESTS}, "<br/>",
            "Positive COVID Tests: ", if(input$checkbox == TRUE){covid_zip_code$NUM_PEOP_TEST_4WEEK} else{covid_zip_code$TOTAL_COVID_TESTS}, "<br/>",
            "Percent Positive COVID Tests: ", if(input$checkbox == TRUE){covid_zip_code$PERCENT_POSITIVE_4WEEK} else{covid_zip_code$PERCENT_POSITIVE}
        ) %>%
            
            lapply(htmltools::HTML)
        
        covid_zip_code %>%
            leaflet %>% 
            # add base map
            addProviderTiles("CartoDB") %>% 
            # mark selected zip code
            
            # add zip codes
            addPolygons(fillColor = ~pal(chosen_parameter),
                        weight = 2,
                        opacity = 1,
                        color = "white",
                        dashArray = "3",
                        fillOpacity = 0.7,
                        highlight = highlightOptions(weight = 2,
                                                     color = "#666",
                                                     dashArray = "",
                                                     fillOpacity = 0.7,
                                                     bringToFront = TRUE),
                        label = labels) %>%
            
            addPolygons(data = covid_zip_code[covid_zip_code$GEOID10 == input$ZipCode, ], 
                        color = "blue", weight = 5, fill = FALSE) %>%
            
            # add legend
            addLegend(pal = pal, 
                      values = ~chosen_parameter,
                      opacity = 0.7, 
                      title = htmltools::HTML(input$radio),
                      position = "bottomright")
        
    }) 
    
    #----------------------------------------
    #tab panel 3 - Hospitals
    
    output$hosMap <- renderLeaflet({
        
        parameter <- covid_zip_code$COVID_CASE_COUNT
        
        # create color palette 
        pal <- colorNumeric(
            palette = "Greens",
            domain = parameter)
        
        # create labels for zipcodes
        labels <- paste(
            "Zip Code: ", covid_zip_code$GEOID10, "<br/>",
            "District: ", covid_zip_code$NEIGHBORHOOD_NAME, "<br/>",
            "Confirmed Case: ", covid_zip_code$COVID_CASE_COUNT) %>%
            lapply(htmltools::HTML)
        
        # add popup features
        pop_boro <- paste('Borough name:',case_by_boro$region,'</br>',
                          'Confirmed cases:',case_by_boro$CASE_COUNT,'</br>',
                          'Death cases:',case_by_boro$DEATH_COUNT,'</br>',
                          'Hospitalized cases:',case_by_boro$HOSPITALIZED_COUNT)
        
        pop_hos=paste(hospitals$Facility.Name)
        
        # add icon feature
        myIcon = makeAwesomeIcon(icon = "medkit", library = "fa",markerColor = "blue",iconColor = "black")
        myIcon_selected = makeAwesomeIcon(icon = "medkit", library = "fa",markerColor = "red",iconColor = "black")
        
        covid_zip_code %>%
            leaflet %>% 
            # add base map
            addProviderTiles("CartoDB") %>% 
            
            # add zip codes
            addPolygons(fillColor = ~pal(parameter),
                        weight = 2,
                        opacity = 1,
                        color = "white",
                        dashArray = "3",
                        fillOpacity = 0.7,
                        highlight = highlightOptions(weight = 2,
                                                     color = "#666",
                                                     dashArray = "",
                                                     fillOpacity = 0.7,
                                                     bringToFront = TRUE),
                        label = labels) %>%
            
            addPolygons(data = covid_zip_code[covid_zip_code$GEOID10 == input$hos_ZipCode, ], 
                        color = "blue", weight = 5, fill = FALSE) %>%
            
            # add legend
            addLegend(pal = pal, 
                      values = ~parameter, 
                      opacity = 0.7, 
                      title = htmltools::HTML("Confirmed COVID Cases <br> 
                                     in NYC by Zip Code"),
                      position = "bottomright")%>%
            
            # add markers for boroughs
            addMarkers(data=case_by_boro,~Long, ~Lat, popup = pop_boro) %>%
            
            # add markers for hospitals
            addAwesomeMarkers(data = hospitals,~long, ~lat, popup = pop_hos,icon=myIcon) %>%
            
            addAwesomeMarkers(data = hospitals[hospitals$zipcode == input$hos_ZipCode, ], 
                              ~long, ~lat, popup = pop_hos,icon=myIcon_selected)
        
    }) 
    
    
    output$hosInfo <- renderTable(
        
        if (sum(input$hos_ZipCode %in% hospitals$zipcode) != 0){
            
            hos_selected <- hospitals[hospitals$zipcode == input$hos_ZipCode,c('Facility.Name','Facility.Type','address','Phone')]
            colnames(hos_selected) <- c('Hospital Name','Type','Address','Phone')
            No. <- seq(1,nrow(hos_selected))
            print(cbind(No., hos_selected))
            
        }
        
        else{print('Cannot find hospitals in this area.')}
    )
    
    #----------------------------------------
    #tab panel 4 - Testing Centers
    
    output$testmap <- renderLeaflet({
        
        parameter <- covid_zip_code$COVID_CASE_COUNT
        
        # create color palette 
        pal <- colorNumeric(
            palette = "Greens",
            domain = parameter)
        
        # create labels for zipcodes
        labels <- paste(
            "Zip Code: ", covid_zip_code$GEOID10, "<br/>",
            "District: ", covid_zip_code$NEIGHBORHOOD_NAME, "<br/>",
            "Confirmed Case: ", covid_zip_code$COVID_CASE_COUNT) %>%
            lapply(htmltools::HTML)
        
        # add popup features
        pop_boro <- paste('Borough name:',case_by_boro$region,'</br>',
                          'Confirmed cases:',case_by_boro$CASE_COUNT,'</br>',
                          'Death cases:',case_by_boro$DEATH_COUNT,'</br>',
                          'Hospitalized cases:',case_by_boro$HOSPITALIZED_COUNT)
        
        pop_hos=paste(testingcenter$Testing_Name)
        
        # add icon feature
        myIcon = makeAwesomeIcon(icon = "medkit", library = "fa",markerColor = "blue",iconColor = "black")
        myIcon_selected = makeAwesomeIcon(icon = "medkit", library = "fa",markerColor = "red",iconColor = "black")
        
        covid_zip_code %>%
            leaflet %>% 
            # add base map
            addProviderTiles("CartoDB") %>% 
            
            # add zip codes
            addPolygons(fillColor = ~pal(parameter),
                        weight = 2,
                        opacity = 1,
                        color = "white",
                        dashArray = "3",
                        fillOpacity = 0.7,
                        highlight = highlightOptions(weight = 2,
                                                     color = "#666",
                                                     dashArray = "",
                                                     fillOpacity = 0.7,
                                                     bringToFront = TRUE),
                        label = labels) %>%
            
            addPolygons(data = covid_zip_code[covid_zip_code$GEOID10 == input$testingcentercode, ], 
                        color = "blue", weight = 5, fill = FALSE) %>%
            
            # add legend
            addLegend(pal = pal, 
                      values = ~parameter, 
                      opacity = 0.7, 
                      title = htmltools::HTML("Confirmed COVID Cases <br> 
                                     in NYC by Zip Code"),
                      position = "bottomright")%>%
            
            # add markers for boroughs
            addMarkers(data=case_by_boro,~Long, ~Lat, popup = pop_boro) %>%
            
            # add markers for testing centers
            addAwesomeMarkers(data = testingcenter,~lon, ~lat, popup = pop_hos,icon=myIcon) %>%
            
            addAwesomeMarkers(data = testingcenter[testingcenter$zip == input$testingcentercode, ], 
                              ~lon, ~lat, popup = pop_hos,icon=myIcon_selected)
        
    }) 
    
    
    output$testingcenterInfo <- renderTable(
        
        if (sum(input$testingcentercode %in% testingcenter$zip) != 0){
            
            testcenter_selected <- testingcenter[testingcenter$zip == input$testingcentercode,c('Testing_Name','Address')]
            colnames(testcenter_selected) <- c('Test Center Name','Address')
            No. <- seq(1,nrow(testcenter_selected))
            print(cbind(No., testcenter_selected))
            
        }
        
        else{print('Cannot find testing centers in this area.')}
    )
    
    
    #----------------------------------------
    #tab panel 4 - Hotels
    
    
    
    #----------------------------------------
    #tab panel 5 - Restaurants 
    
    
    
    #----------------------------------------
    #tab panel 6 - Averages 
    
    averages_cumulative <- as.data.frame(covid_zip_code) %>%
        select(COVID_CASE_COUNT, COVID_DEATH_COUNT, TOTAL_COVID_TESTS, TOTAL_POSITIVE_TESTS, PERCENT_POSITIVE) %>%
        summarise_all(mean)
    
    averages_recent <- as.data.frame(covid_zip_code) %>%
        select(COVID_CASE_COUNT_4WEEK, COVID_DEATH_COUNT_4WEEK, NUM_PEOP_TEST_4WEEK, TOTAL_POSITIVE_TESTS_4WEEK, PERCENT_POSITIVE_4WEEK) %>%
        summarise_all(mean)
    
    averages_borough_cumulative <- as.data.frame(covid_zip_code) %>% group_by(BOROUGH_GROUP) %>% 
        select(COVID_CASE_COUNT, COVID_DEATH_COUNT, TOTAL_COVID_TESTS, TOTAL_POSITIVE_TESTS, PERCENT_POSITIVE) %>%
        summarise_all(mean)
    
    averages_borough_recent <- as.data.frame(covid_zip_code) %>% group_by(BOROUGH_GROUP) %>% 
        select(COVID_CASE_COUNT_4WEEK, COVID_DEATH_COUNT_4WEEK, NUM_PEOP_TEST_4WEEK, TOTAL_POSITIVE_TESTS_4WEEK, PERCENT_POSITIVE_4WEEK) %>%
        summarise_all(mean)
    
    output$myTable1 <- renderTable(averages_cumulative)
    output$myTable3 <- renderTable(averages_borough_cumulative)
    
    
    output$myTable2 <- renderTable(averages_recent)
    output$myTable4 <- renderTable(averages_borough_recent)
    
    #----------------------------------------
    #tab panel 7 - Sources
    
    
    
    
    
    
})