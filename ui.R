grid_template <- grid_template(
  default = list(
    areas = rbind(
      c("title", "map"),
      c("info", "map"),
      c("user", "map")
    ),
    cols_width = c("400px", "1fr"),
    rows_height = c("50px", "auto", "200px")
  ),
  mobile = list(
    areas = rbind(
      "title",
      "info",
      "map",
      "user"
    ),
    rows_height = c("70px", "400px", "auto", "200px"),
    cols_width = c("100%")
  )
)

ui = semanticPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css"),
  ),
  grid(
    grid_template,
    title = h1("Vessel Tracker", style = "padding-left: 10px; color: white"),
    info =  uiOutput("sidebar"),
    map =   leaflet::leafletOutput("map", width = '100%', height = '100%'),
    user =  dropdownUI("dropdown1")
  )
)
