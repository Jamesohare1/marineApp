info_Modal_Content <- 
  tagList(
    h3("Display"),
    p("The app displays the observation when a 'selected ship' sailed the longest distance between two consecutive observations."),
    p("All summary information shown within the app is based on this longest observation."),
    br(),
    hr(),
    
    h3("Distance Calculation"),
    p("Distance has been calculated using the haversine formula."),
    p("I have implemented a vectorised version of this calculation. Versions in available packages (e.g. 'geosphere') only accept pairs of points, which would not scale well to the number of observations in the ships dataset."),
    p("The haversine distance is not accurate for all nautical distance calculations. However, given the number of observations, an implementation which 'avoided land' when calculating distance would have been prohibitively slow."),
    br(),
    hr(),
    
    h3("Bearing Calculation"),
    p("Bearing ('angle in a spherical co-ordinate system') has been calculated using the forward-Azimuth calculation."),
    br(),
    hr(),
    
    h3("Average Speed Calculation"),
    p("The average speed has been calculated using the haversine distance and time between observations."),
    br(),
    hr(),
    
    h3("Data Cleansing"),
    p("Some ships were seen to have more than one observation with the same datetime."),
    p("These observations were removed due to unreliability."),
    br(),
    hr(),
    
    p("Mathematical formulae for the haversine distance and the bearing have been taken from the  website linked below."),
    p("Calculations were checked against corresponding functions from the 'geosphere' package"),
    a("Calculate distance and bearing...", href="http://www.movable-type.co.uk/scripts/latlong.html?from=47.80423,-120.03866&to=47.830481,-120.00987")
)