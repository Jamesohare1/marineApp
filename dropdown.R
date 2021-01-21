dropdownUI <- function(id){
  ns <- NS(id)
  
  tagList(div(
    #dropdown for ship type
    shiny.semantic::selectInput(ns("ship_type"), 
                                label = "Select Ship Type",
                                choices = get_ship_types(ships),
                                selected = "Cargo"),
    #dropdown for ship name
    shiny.semantic::selectInput(ns("ship_name"), 
                                label = "Select Ship",
                                choices = "Cargo",
                                selected = "KAROLI"),
  style = "padding-right: 10px")
  )
}


dropdown <- function(id){
  moduleServer(
    id,
    function(input, output, session) {
      
      #updates the dropdown for ship name when ship type is altered
      observe({
        shiny.semantic::updateSelectInput(session, "ship_name", 
                                          label = "Select Ship",
                                          choices = update_ship_choices(ships, input$ship_type))
      })
      
      #filters the data to keep only the 2 observations of interest
      observations <- reactive({

        get_ship_observations(ships, input$ship_type, input$ship_name)
        
      })
     
      return(observations)
    }
  )
}