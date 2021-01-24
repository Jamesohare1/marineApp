server = shinyServer(function(input, output, session) {

  #show modal
  observeEvent(input$show_info, {
    create_modal(modal(
      id = "simple-modal",
      title = "App Information",
      header = list("App Information"),
      content = info_Modal_Content
    ))
  })
  
  #Call the user inputs module, and retrieve inputs
  user_inputs <- user_inputs("user_inputs_1")
  
  #Get total observations for selected ship
  observations_total <- reactive({
    get_total_observations(ships, user_inputs$ship_type(), user_inputs$ship_name())
  })
  
  #Get observations of interest
  observations_longest <- reactive({
    get_top_two_observations(ships, user_inputs$ship_type(), user_inputs$ship_name())
  })

  #calculate the distance traveled
  dist_traveled <- reactive({
    get_dist_traveled(observations_longest())
  })
  
  #Render the total number of observations for selected ship
  output$observations_total <- renderText({
    format(observations_total(), big.mark = ",")
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
    get_duration(observations_longest())
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
          c("num_observations", "num_observations"),
          c("destination", "duration"),
          c("start_date", "end_date"),
          c("speed", "bearing")
        ),
        cols_width = c("50%", "50%"),
        rows_height = c("100px", "100px", "120px", "120px", "120px")
      )),
      area_styles = list(status = "padding-right: 10px",
                         num_observations = "padding-right: 10px",
                         destination = "padding-left: 10px; padding-right: 5px",
                         duration = "padding-left: 5px; padding-right: 10px",
                         start_date = "padding-left: 10px; padding-right: 5px",
                         end_date = "padding-left: 5px; padding-right: 10px",
                         speed = "padding-left: 10px; padding-right: 5px",
                         bearing = "padding-left: 5px; padding-right: 10px"
                         ),

      status = div(class = "ui message success", style = "margin-top: 10px; margin-left: 10px",
                   div(class = "header", style = "margin-bottom: 5px", textOutput("distance")),
                   div(class = "description", paste0("Largest distance travelled by ", user_inputs$ship_name()))),
      num_observations = div(class = "ui message success", style = "margin-left: 10px",
                   div(class = "header", style = "margin-bottom: 5px", textOutput("observations_total")),
                   div(class = "description", paste0("Total observations for ", user_inputs$ship_name()))),

      destination = card(
        style = "border-radius: 1; width: 100%; height: 110px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", icon("home"), "Destination"),
            div(class = "description", style = "font-size: 15px; color: darkgreen", textOutput("destination"))
        )
      ),

      duration = card(
        style = "border-radius: 1; width: 100%; height: 110px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", icon("stopwatch"), "Duration"),
            div(class = "description", style = "font-size: 15px; color: darkgreen", uiOutput("journey_time"))
        )
      ),

      start_date = card(
        style = "border-radius: 1; width: 100%; height: 110px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", icon("hourglass start"), "Start Time"),
            div(class = "description", style = "font-size: 15px; color: darkgreen", uiOutput("start_time"))
        )
      ),

      end_date = card(
        style = "border-radius: 1; width: 100%; height: 110px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", icon("hourglass end"), "End Time"),
            div(class = "description", style = "font-size: 15px; color: darkgreen", uiOutput("end_time"))
        )
      ),

      speed = card(
        style = "border-radius: 1; width: 100%; height: 110px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", icon("ship"), "Avg speed"),
            div(class = "description", style = "font-size: 15px; color: darkgreen", textOutput("speed"))
        )
      ),

      bearing = card(
        style = "border-radius: 1; width: 100%; height: 110px; background: #ebf5f7",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", icon("compass"), "Bearing"),
            div(class = "description", style = "font-size: 15px; color: darkgreen", textOutput("bearing"))
        )
      )
    )
  })
})