server = shinyServer(function(input, output, session) {

  observations_longest <- dropdown("dropdown1")
  
  distance_max <- reactive({
    observations_longest()$distance[2]
  })

  output$map <- leaflet::renderLeaflet({

    observations_longest() %>%
    leaflet() %>%
    #setView(18, 54, zoom = 8) %>%
    addTiles() %>%
    addCircleMarkers(~LON,
                     ~LAT,
                     #radius = log(nasa_fireball$impact_e),
                     #label = nasa_fireball$date,
                     weight = 2)

    #
    #   #this shows circles on maps and allows popups showing info.
    #   #about the event
    #   addCircleMarkers(
    #     popup = ~ summary, radius = ~ sqrt(fatalities)*3,
    #     fillColor = 'red', color = 'red', weight = 1
    #   )
  })

  output$sidebar <- renderUI({
      uiOutput("sailing_stats")
  })

  output$distance <- renderText({
    paste0(format(distance_max(), big.mark = ",", nsmall = 2), " meters")
  })

  output$sailing_stats <- renderUI({

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
            div(class = "description", "test")
        )
      ),

      time_between = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Journey Time"),
            div(class = "description", "test")
        )
      ),

      start_date = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Start Time"),
            div(class = "description", "test")
        )
      ),

      end_date = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "End Time"),
            div(class = "description", "test")
        )
      ),

      speed = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Average Speed"),
            div(class = "description", "test")
        )
      ),

      course = card(
        style = "border-radius: 0; width: 100%; height: 150px; background: #efefef",
        div(class = "content",
            div(class = "header", style = "margin-bottom: 10px", "Course"),
            div(class = "description", "test")
        )
      )
    )
  })
})