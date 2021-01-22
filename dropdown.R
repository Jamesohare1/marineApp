dropdownUI <- function(id){
  ns <- NS(id)
  
  tagList(div(
    #dropdown for ship type
    shiny.semantic::selectInput(ns("ship_type"), 
                                label = "Select Ship Type",
                                choices = ship_types,
                                selected = "Passenger"),
    #dropdown for ship name
    shiny.semantic::selectInput(ns("ship_name"), 
                                label = "Select Ship",
                                choices = default_ship_names,
                                selected = head(default_ship_names, 1)),
  style = "padding-right: 10px")
  )
}


dropdown <- function(id){
  moduleServer(
    id,
    function(input, output, session) {
      
      #updates the dropdown for ship name when ship type is altered
      observe({
        choices <- update_ship_choices(ships, input$ship_type)
        shiny.semantic::updateSelectInput(session, "ship_name", 
                                          label = "Select Ship",
                                          choices = choices,
                                          selected = head(choices,1))
      })
     
      #return inputs to main server
      return(list(reactive({input$ship_type}), 
                  reactive({input$ship_name})))
    }
  )
}