#Calculate distance given two sets of coordinates (lat, lon)
haversine_dist <- function(lat1, lon1, lat2, lon2){
  #https://www.movable-type.co.uk/scripts/latlong.html

  r = 6378137
  
  phi_1 <- lat1 * pi/180
  phi_2 <- lat2 * pi/180
  delta_phi <- (lat2-lat1) * pi/180;
  delta_lambda <- (lon2-lon1) * pi/180;
  
  a <- sin(delta_phi/2)**2 +
       cos(phi_1) * cos(phi_2) * sin(delta_lambda/2) ** 2;
  
  c <- 2 * atan2(sqrt(a), sqrt(1-a));
  
  d <- r * c #distance in meters
  
}


#Returns sorted ship types
get_ship_types <- function(ships){
  ships %>%
    select(ship_type) %>%
    unique() %>% 
    pull() %>%
    sort()
}


#updates available ship choices depending on which ship type is selected
update_ship_choices <- function(ships, input_ship_type){
  ships %>% filter(ship_type == input_ship_type) %>%
    select(SHIPNAME) %>%
    unique() %>%
    pull() %>%
    sort()
}


#return relevant observations for a selected ship type
get_ship_observations <- function(ships, input_ship_type, input_ship_name){
  
  #filter data for ship type and name and arrange by date
  observations <- ships %>%
    filter(ship_type == input_ship_type, SHIPNAME == input_ship_name) %>%
    arrange(desc(DATETIME))

  #calculate distance traveled
  observations <- observations %>%
    mutate(LAT_prev = dplyr::lead(LAT), LON_prev = dplyr::lead(LON)) %>%
    mutate(distance = haversine_dist(LAT_prev, LON_prev, LAT, LON))

  #find most recent observation with longest distance
  longest_index <- which(observations$distance == max(observations$distance, na.rm = TRUE))[1]
  
  
  #Return the observation along with prior observation
  observations[c(longest_index,longest_index+1),] %>% arrange(DATETIME)
}


#returns the distance traveled between two observations of interest
get_dist_traveled <- function(observations_longest){
  observations_longest$distance[2]
}

get_destination <- function(observations_longest){
  observations_longest$DESTINATION[2]
}


get_start_datetime <- function(observations_longest){
  dateTime <- observations_longest$DATETIME[1]
  tidy_dateTime(dateTime)
}


get_end_datetime <- function(observations_longest){
  dateTime <- observations_longest$DATETIME[2]
  tidy_dateTime(dateTime)
}


get_journey_time <- function(observations_longest){
  
  start <- as_datetime(observations_longest$DATETIME[1])
  end  <- as_datetime(observations_longest$DATETIME[2])
  time_interval <- start %--% end
  duration_seconds <- as.duration(time_interval)
  period <- as.period(duration_seconds)

  parse_timePeriod(period)
  
}


parse_timePeriod <- function(period){
  
  period <- as.character(period)

  years   <- extract_units(period, pattern = "\\d\\d?y")
  months  <- extract_units(period, pattern = "\\d\\d?m")
  days    <- extract_units(period, pattern = "\\d\\d?d")
  hours   <- extract_units(period, pattern = "\\d\\d?H")
  minutes <- extract_units(period, pattern = "\\d\\d?M")
  seconds <- extract_units(period, pattern = "\\d\\d?S")

  time_tidied <- tagList()
  time_tidied <- tagAppendChild(time_tidied, if(years != 0) tags$div(tidy_time(year, "Year")))
  time_tidied <- tagAppendChild(time_tidied, if(months != 0) tags$div(tidy_time(months, "Month")))
  time_tidied <- tagAppendChild(time_tidied, if(days != 0) tags$div(tidy_time(days, "Day")))
  time_tidied <- tagAppendChild(time_tidied, if(hours != 0) tags$div(tidy_time(hours, "Hour")))
  time_tidied <- tagAppendChild(time_tidied, if(minutes != 0) tags$div(tidy_time(minutes, "Minute")))
  time_tidied <- tagAppendChild(time_tidied, if(seconds != 0) tags$div(tidy_time(seconds, "Second")))

  time_tidied  
}

tidy_dateTime <- function(dateTime){

  time <- format(dateTime, format = "%H:%M:%S")
  date <- as.Date((dateTime))
  
  tagList(tags$div(paste("Date:", date)),
          tags$div(paste("Time:", time)))

}


extract_units <- function(period, pattern){
  units_chr <- period %>% str_extract(pattern = pattern)
  if(is.na(units_chr)){
    return(0)
  } else{
    as.numeric(str_extract(units_chr, pattern = "\\d\\d?"))
  }
}


tidy_time <- function(units, text){
  
  if(units < 10){ units = str_c("0", units)}
  
  ifelse(units == 1, 
         str_c(units, text, sep = " "), 
         str_c(units, " ", text, "s"))
}


get_average_speed <- function(observations_longest){
  
  distance <- observations_longest$distance[2]
  
  start <- as_datetime(observations_longest$DATETIME[1])
  end  <- as_datetime(observations_longest$DATETIME[2])
  duration_seconds <- as.numeric(as.duration(start %--% end))
  
  paste(round(distance/duration_seconds, 3), "meters/second")
  
}


get_bearing <- function(observations_longest){
  #http://www.movable-type.co.uk/scripts/latlong.html?from=47.80423,-120.03866&to=47.830481,-120.00987
  
  to_radains <- pi/180
  
  lat2 <- observations_longest$LAT[1] * to_radains
  lon2 <- observations_longest$LON[1] * to_radains 
  lat1 <- observations_longest$LAT[2] * to_radains
  lon1 <- observations_longest$LON[2] * to_radains

  lon_delta <- lon2 - lon1
  y <- sin(lon_delta) * cos(lat2)
  x <- cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(lon_delta)
  tetha <- atan2(y, x)
  degrees <- (tetha/to_radains + 360) %% 360

  paste(round(degrees, 2), "degrees")
  
}


draw_arrow <- function(observations_longest){
  
  x <- c(observations_longest$LAT[1], observations_longest$LAT[2])
  y <- c(observations_longest$LON[1], observations_longest$LON[2])
  
  data <- data.frame(x,y)
  
  ggplot(data, aes(x = x, y=y)) + 
    geom_segment(aes(x = x[1], y = y[1], xend = x[2], yend = y[2]),
                 arrow = arrow(length = unit(1, "cm")), color = "darkgreen", size = 2) +
    theme(panel.background = element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.title.x=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank(),
          axis.title.y=element_blank()) +
    coord_fixed()
  
  
}


