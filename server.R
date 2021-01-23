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
    paste0(format(round(dist_traveled(),2), big.mark = ","), " meters")
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
    get_end_datetime(observations_longest())
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
                         destination = "padding-left: 10px; padding-right: 10px",
                         time_between = "padding-left: 5px; padding-right: 10px",
                         start_date = "padding-left: 10px; padding-right: 10px",
                         end_date = "padding-right: 10px; padding-left: 5px",
                         speed = "padding-left: 10px; padding-right: 10px",
                         bearing = "padding-left: 5px; padding-right: 10px"
                         ),

      status = div(class = "ui message success", style = "margin-left: 10px",
                   div(class = "header", style = "margin-bottom: 5px", textOutput("distance")),
                   div(class = "description", "Straight-line distance travelled")),

      destination = card(
        style = "border-radius: 1; border-width: medium; height: 150px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 20px", icon("home"), "Destination"),
            div(class = "description", style = "margin-left: 30px; font-size: 15px; color: darkgreen", textOutput("destination"))
        )
      ),

      time_between = card(
        style = "border-radius: 1; width: 100%; height: 150px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 20px", icon("stopwatch"), "Journey Time"),
            div(class = "description", style = "margin-left: 30px; font-size: 15px; color: darkgreen", uiOutput("journey_time"))
        )
      ),

      start_date = card(
        style = "border-radius: 1; width: 100%; height: 150px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 20px", icon("hourglass start"), "Journey Start"),
            div(class = "description", style = "margin-left: 30px; font-size: 15px; color: darkgreen", uiOutput("start_time"))
        )
      ),

      end_date = card(
        style = "border-radius: 1; width: 100%; height: 150px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 20px", icon("hourglass end"), "Journey End"),
            div(class = "description", style = "margin-left: 30px; font-size: 15px; color: darkgreen", uiOutput("end_time"))
        )
      ),

      speed = card(
        style = "border-radius: 1; width: 100%; height: 150px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 20px", icon("ship"), "Average Speed"),
            div(class = "description", style = "margin-left: 30px; font-size: 15px; color: darkgreen", textOutput("speed"))
        )
      ),

      bearing = card(
        style = "border-radius: 1; width: 100%; height: 150px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 20px", icon("compass"), "Bearing"),
            div(class = "description", style = "margin-left: 30px; font-size: 15px; color: darkgreen", textOutput("bearing"))
        )
      )
    )
  })
})