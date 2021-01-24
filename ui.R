#Grid Template sourced from https://github.com/Appsilon/shiny.semantic-hackathon-2020/tree/master/polluter-alert

grid_template <- grid_template(
  default = list(
    areas = rbind(
      c("title", "map"),
      c("summary", "map"),
      c("user", "map")
    ),
    cols_width = c("400px", "1fr"),
    rows_height = c("50px", "auto", "200px")
  ),
  mobile = list(
    areas = rbind(
      "title",
      "map",
      "user",
      "summary"
    ),
    rows_height = c("60px", "400px", "200px", "auto"),
    cols_width = c("100%")
  )
)

ui = semanticPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  ),
  grid(
    grid_template,
    title = div(div(style="display:inline-block; padding-left: 10px; color: white; padding-top: 5px", h1("Vessel Tracker")), 
                div(style="display:inline-block; padding-right: 10px; padding-top: 7px; float: right", 
                    actionButton("show_info", label = "info"))),
    summary =  uiOutput("sidebar"),
    user =  user_inputsUI("user_inputs_1"),
    map =   leaflet::leafletOutput("map"),
    
  )
)
