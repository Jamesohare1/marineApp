info_Modal_Content <- 
  tagList(
    h3("Display"),
    p("The app displays the longest distance travelled between two consecutive observations for the ship selected."),
    
    h3("Distance Calculation"),
    p("Distance has been calculated using the haversine formula."),
    p("I have implemented a vectorised version of this calculation. Versions in available packages (e.g. 'geosphere') only accept pairs of points, which would not scale well to the number of observations in the ships dataset."),
    p("The haversine distance is not entirely accurate for all nautical distance calculations. However, given the number of observations been dealt with, an implementation which 'avoided land' would have been prohibively slow."),
    
    h3("Bearing Calculation"),
    p("Bearing ('angle in a spherical co-ordinate system') has been calculated using the forward-Azimuth calculation."),
    
    h3("Average Speed Calculation"),
    p("The average speed has been calculated using the haversine distance and time between observations."),
    br(),
    hr(),
    p("Mathematical formulae for the haversine distance and the bearing have been taken from the  website linked below."),
    p("Calculations were checked against corresponding functions from the 'geosphere' package"),
    a("Calculate distance and bearing...", href="http://www.movable-type.co.uk/scripts/latlong.html?from=47.80423,-120.03866&to=47.830481,-120.00987")
)