server = shinyServer(function(input, output, session) {
  
  #Call the dropdown module, and retrieve inputs
  dropdown_inputs <- dropdown("dropdown1")
  input_ship_type <- dropdown_inputs[[1]]
  input_ship_name <- dropdown_inputs[[2]]
  
  
  #Get observations of interest
  observations_longest <- reactive({
    get_ship_observations(ships, input_ship_type(), input_ship_name())
  })
  

  #calculate the distance traveled
  dist_traveled <- reactive({
    get_dist_traveled(observations_longest())
  })
  
  
  #Render the distance traveled
  output$distance <- renderText({
    paste0(format(dist_traveled(), big.mark = ",", nsmall = 2), " meters")
  })
  
  
  #Render the destination
  output$destination <- renderText({
    get_destination(observations_longest())
  })
  
  
  #Render the journey time
  output$journey_time <- renderUI({
    get_journey_time(observations_longest())
  })
  
  
  #Render the start time
  output$start_time <- renderUI({
    get_start_datetime(observations_longest())
  })
  
  
  #Render the end time
  output$end_time <- renderUI({
    get_start_datetime(observations_longest())
  })

  
  #Render the average speed
  output$speed <- renderText({
    get_average_speed(observations_longest())
  })
  
  
  #Render the average bearing
  output$bearing <- renderText({
    get_bearing(observations_longest())
  })

  
  #Render the leaflet map
  output$map <- leaflet::renderLeaflet({
    observations_longest() %>%
      leaflet() %>%
      #setView(lon_end(), lat_end(), zoom = ) %>%
      addTiles() %>%
      addCircleMarkers(~LON[2], ~LAT[2],
                       label = "Start Point",
                       fillColor = 'green', color = 'green',
                       weight = 3,
                       opacity = 1,
                       fillOpacity = 0.5) %>%
      addCircleMarkers(~LON[1],~LAT[1],
                       label = "End Point",
                       fillColor = 'red', color = 'red',
                       weight = 3,
                       opacity = 1,
                       fillOpacity = 0.5)
  })
  
  
  #Render the summary stats in the sidebar
  output$sidebar <- renderUI({

    grid(
      grid_template = grid_template(default = list(
        areas = rbind(
          c("status", "status"),
          c("destination", "time_between"),
          c("start_date", "end_date"),
          c("speed", "bearing")
        ),
        cols_width = c("50%", "50%"),
        rows_height = c("80px", "160px", "160px", "160px")
      )),
      area_styles = list(status = "padding-right: 10px",
                         destination = "padding-left: 5px; padding-right: 10px",
                         time_between = "padding-left: 5px; padding-right: 10px",
                         start_date = "padding-right: 10px; padding-left: 5px",
                         end_date = "padding-right: 10px; padding-left: 5px",
                         speed = "padding-right: 10px; padding-left: 5px",
                         bearing = "padding-left: 5px; padding-right: 10px"
                         ),

      status = div(class = "ui message success",
                   div(class = "header", "Distance travelled"),
                   textOutput("distance")),

      destination = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Destination"),
            div(class = "description", textOutput("destination"))
        )
      ),

      time_between = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Journey Time"),
            div(class = "description", uiOutput("journey_time"))
        )
      ),

      start_date = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Journey Start"),
            div(class = "description", uiOutput("start_time"))
        )
      ),

      end_date = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Journey End"),
            div(class = "description", uiOutput("end_time"))
        )
      ),

      speed = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Average Speed"),
            div(class = "description", textOutput("speed"))
        )
      ),

      bearing = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Average Bearing"),
            div(class = "description", textOutput("bearing"))
        )
      )
    )
  })
})