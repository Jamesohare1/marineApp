server = shinyServer(function(input, output, session) {

  #Call the dropdown module...
  #store 2 observations of interest in variable
  observations_longest <- dropdown("dropdown1")
  
  #calculate the distance traveled
  dist_traveled <- reactive({
    get_dist_traveled (observations_longest())
  })

  #Render the leaflet map
  output$map <- leaflet::renderLeaflet({

    observations_longest() %>%
    leaflet() %>%
    #setView(18, 54, zoom = 8) %>%
    addTiles() %>%
    addCircleMarkers(~LON,
                     ~LAT,
                     #popup = ~ summary,
                     #label = nasa_fireball$date,
                     #fillColor = 'red', color = 'red'
                     weight = 2)
  })
  
  #Render the distance traveled
  output$distance <- renderText({
    paste0(format(dist_traveled(), big.mark = ",", nsmall = 2), " meters")
  })

  #Render the summary stats in the sidebar
  output$sidebar <- renderUI({

    grid(
      grid_template = grid_template(default = list(
        areas = rbind(
          c("status", "status"),
          c("destination", "time_between"),
          c("start_date", "end_date"),
          c("speed", "course")
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
                         course = "padding-left: 5px; padding-right: 10px"
                         ),

      status = div(class = "ui message success",
                   div(class = "header", "Distance travelled"),
                   textOutput("distance")),

      destination = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Destination"),
            div(class = "description", get_destination(observations_longest()))
        )
      ),

      time_between = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Journey Time"),
            div(class = "description", get_journey_time(observations_longest()))
        )
      ),

      start_date = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Start Time"),
            div(class = "description", get_start_datetime(observations_longest()))
        )
      ),

      end_date = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "End Time"),
            div(class = "description", get_end_datetime(observations_longest()))
        )
      ),

      speed = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Average Speed"),
            div(class = "description", get_average_speed(observations_longest()))
        )
      ),

      course = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Course"),
            div(class = "description", get_course(observations_longest()))
        )
      )
    )
  })
})