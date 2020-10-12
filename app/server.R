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
library(ggplot2)


#can run RData directly to get the necessary date for the app
#global.r will enable us to get new data everyday
#update data with automated script
load('../app/output/covid_zip_code.RData')



shinyServer(function(input, output) {
    #----------------------------------------
    #tab panel 0 - Home
    
    
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
    #tab panel 3 - Hospitals & Testing Center
    
    output$hos_tc_Map <- renderLeaflet({
        
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
        pop_test=paste(testingcenter$Testing_Name)
        
        # add icon feature
        myIcon = makeAwesomeIcon(icon = "medkit", library = "fa",markerColor = "blue",iconColor = "black")
        myIcon_selected = makeAwesomeIcon(icon = "medkit", library = "fa",markerColor = "red",iconColor = "black")
        
        df <- if (input$choice=="hos"){hospitals}else{testingcenter}
        
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
            
            addPolygons(data = covid_zip_code[covid_zip_code$GEOID10 == input$hos_tc_ZipCode, ], 
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
        
            addAwesomeMarkers(data = df,if (input$choice=="hos"){~long}else{~lon}, ~lat, 
                              popup = if (input$choice=="hos"){pop_hos}else{pop_test},icon=myIcon) %>%
            
            addAwesomeMarkers(data = df[df$zip == input$hos_tc_ZipCode, ], 
                              if (input$choice=="hos"){~long}else{~lon}, ~lat, 
                              popup = if (input$choice=="hos"){pop_hos}else{pop_test},icon=myIcon_selected)
        
    }) 
    
    
    output$hos_tc_Info <- renderTable(
        
        if (input$choice=="hos"){
            
            if (sum(input$hos_tc_ZipCode %in% hospitals$zipcode) != 0){
                
                hos_selected <- hospitals[hospitals$zipcode == input$hos_tc_ZipCode,c('Facility.Name','Facility.Type','address','Phone')]
                colnames(hos_selected) <- c('Hospital Name','Type','Address','Phone')
                No. <- seq(1,nrow(hos_selected))
                print(cbind(No., hos_selected))
                
            }
            
            else{print('Cannot find hospitals in this area.')}
            
        }
        
        else{
            
            if (sum(input$hos_tc_ZipCode %in% testingcenter$zip) != 0){
                
                testcenter_selected <- testingcenter[testingcenter$zip == input$hos_tc_ZipCode,c('Testing_Name','Address')]
                colnames(testcenter_selected) <- c('Test Center Name','Address')
                No. <- seq(1,nrow(testcenter_selected))
                print(cbind(No., testcenter_selected))
                
            }
            
            else{print('Cannot find testing centers in this area.')}
            
        }
        
    )
    
  
    #----------------------------------------
    #tab panel 5 - Hotels
    
    output$hotelMap <- renderLeaflet({
        
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
        
        pop_hotels=paste(hotels$name)
        
        # add icon feature
        myIcon = makeAwesomeIcon(icon = "hotel", library = "fa",markerColor = "blue",iconColor = "black")
        myIcon_selected = makeAwesomeIcon(icon = "hotel", library = "fa",markerColor = "green",iconColor = "black")
        
        covid_zip_code[covid_zip_code$GEOID10 == input$hotelcode, ] %>%
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
            
            addPolygons(data = covid_zip_code[covid_zip_code$GEOID10 == input$hotelcode, ], 
                        color = "blue", weight = 5, fill = FALSE) %>%
            
            # add legend
            addLegend(pal = pal, 
                      values = ~parameter, 
                      opacity = 0.7, 
                      title = htmltools::HTML("Confirmed COVID Cases <br> 
                                     in NYC by Zip Code"),
                      position = "bottomright")%>%
            
          # add markers for boroughs
          # addMarkers(data=case_by_boro,~Long, ~Lat, popup = pop_boro) %>%
          
          # add markers for hotels
          addAwesomeMarkers(data = hotels[hotels$postal_code == input$hotelcode, ], ~longitude, ~latitude, popup = pop_hotels, icon=myIcon) %>%
          
          addAwesomeMarkers(data = hotels[(hotels$postal_code == input$hotelcode | hotels$city == input$hotelcity) & 
                                            hotels$rating == input$hotelrate, ] ,
                            ~longitude, ~latitude, popup = pop_hotels,icon = myIcon_selected)
        
    }) 
    
    
    
    #Adding the table contains hotel's information
    output$hotelInfo <- DT::renderDataTable(DT::datatable({
        hotel_table <- hotels[c('name','address','city','postal_code','rating','highest_room_rate', 'lowest_room_rate')]
        if (input$hotelcode != "All") {
            hotel_table <- hotel_table[hotel_table$postal_code == input$hotelcode,]
        }
        if (input$hotelcity != "All") {
            hotel_table <- hotel_table[hotel_table$city == input$hotelcity,]
        }
        if (input$hotelrate != "All") {
            hotel_table <- hotel_table[hotel_table$rating == input$hotelrate,]
        }
        hotel_table
    }))

    
    
    #----------------------------------------
    #tab panel 6 - Restaurants 
    
    output$restaurant_Map <- renderLeaflet({
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
        pop_restaurant = paste(Restaurant$Restaurant.Name)
        # add icon feature
        myIcon_selected = makeAwesomeIcon(icon = "utensils", library = "fa", markerColor = "orange",iconColor = "black")
        covid_zip_code[covid_zip_code$GEOID10 == input$restaurant_ZipCode, ] %>% leaflet %>% 
            #setView(center_zipcode[center_zipcode$Zip == input$restaurant_ZipCode,]$Longitude, center_zipcode[center_zipcode$Zip == input$restaurant_ZipCode,]$Latitude, zoom = 15) %>%
            # add base map
            addProviderTiles("CartoDB") %>% 
            # add zip codes
            addPolygons(fillColor = ~ pal(parameter),weight = 2, opacity = 1,
                        color = "white", dashArray = "3", fillOpacity = 0.7,
                        highlight = highlightOptions(weight = 2, color = "#666", dashArray = "", 
                                                     fillOpacity = 0.7, bringToFront = TRUE),
                        label = labels) %>%
            addPolygons(data = covid_zip_code[covid_zip_code$GEOID10 == input$restaurant_ZipCode, ], 
                        color = "blue", weight = 5, fill = FALSE) %>%
            # add legend
            addLegend(pal = pal, values = ~ parameter, opacity = 0.7, 
                      title = htmltools::HTML("Confirmed COVID Cases <br> in NYC by Zip Code"),
                      position = "bottomright")%>%
            # add markers for boroughs
            #addMarkers(data = case_by_boro, ~ Long, ~ Lat, popup = pop_boro) %>%
            # add markers for Restaurant
            addAwesomeMarkers(data = Restaurant[Restaurant$Postcode == input$restaurant_ZipCode & 
                                                    Restaurant$GRADE %in% input$Grade & 
                                                    Restaurant$categories %in% input$categories, ], 
                              ~ Longitude, ~ Latitude, popup = pop_restaurant,icon = myIcon_selected)
        
    }) 
    output$restaurant_Info <- DT::renderDataTable(
        if (sum(input$restaurant_ZipCode %in% Restaurant$Postcode) != 0){
            restaurant_selected <- Restaurant[Restaurant$Postcode == input$restaurant_ZipCode & 
                                                  Restaurant$GRADE %in% input$Grade & 
                                                  Restaurant$categories %in% input$categories, ] %>%
              select('Restaurant.Name', 'GRADE', 'categories', 'CUISINE.DESCRIPTION','Business.Address')
            
            #colnames(restaurant_selected) <- c('Restaurant.Name','GRADE', 'categories', 'CUISINE.DESCRIPTION','Business.Address')
            #No. <- seq(1, nrow(restaurant_selected))
            #tb <- cbind(No., restaurant_selected)
            DT::datatable(restaurant_selected, options = list(lengthMenu = list(c(5, 15, -1), c('5', '15', 'All')), pageLength = 5))
        }
        else{print('Cannot find restaurants in this area.')}
    )
    
    #----------------------------------------
    #tab panel 7 - Averages 
    
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
    
    
   
    output$barplot1 <-renderPlot({
        ggplot(data=case_by_boro, aes(x=case_by_boro$BOROUGH_GROUP, y = case_by_boro$CASE_COUNT )) +
            geom_bar(stat="identity", fill="steelblue", width=0.5) +
            geom_text(aes(label=case_by_boro$CASE_COUNT), position=position_dodge(width=0.9), vjust=-0.25) +
            theme_classic()
    })
    
    
    #----------------------------------------
    #tab panel 8 - Sources
    
    
    
    
    
    
})