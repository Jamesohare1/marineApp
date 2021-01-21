dropdownUI <- function(id){
  ns <- NS(id)
  
  tagList(div(
    shiny.semantic::selectInput(ns("ship_type"), "Select Ship Type",
                                choices = ships %>%
                                  select(ship_type) %>%
                                  unique() %>% 
                                  pull(),
                                selected = "Cargo"),
    shiny.semantic::selectInput(ns("ship_name"), "Select Ship",
                                choices = ships %>%
                                  select(SHIPNAME) %>%
                                  unique() %>% 
                                  pull(),
                                selected = "KAROLI"),
  style = "padding-right: 10px")
  )
}

dropdown <- function(id){
  moduleServer(
    id,
    function(input, output, session) {

      observe({
        choices <- ships %>% filter(ship_type == input$ship_type) %>%
          select(SHIPNAME) %>%
          unique() %>%
          pull()
        
        shiny.semantic::updateSelectInput(session, "ship_name", "Select Ship",
                                          choices = choices)
      })
      
      observations <- reactive({

          #filter data for ship type and name and arrange by date
          observations <- ships %>%
          filter(ship_type == input$ship_type, SHIPNAME == input$ship_name) %>%
          arrange(desc(date))
        
          #calculate distance traveled
          observations <- observations %>%
            mutate(LAT_prev = dplyr::lag(LAT), LON_prev = dplyr::lag(LON)) %>%
            mutate(distance = haversine_dist(LAT_prev, LON_prev, LAT, LON))
          
          #find most recent observation with longest distance
          longest_index <- which(observations$distance == max(observations$distance, na.rm = TRUE))[1]
          
          #Return the observations along with prior observation
          observations[c(longest_index-1,longest_index),]
      })
     
      return(observations)
    }
  )
}