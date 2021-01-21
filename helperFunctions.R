#Calculate distance given two sets of coordinates (lat, lon)
haversine_dist <- function(lat1, lon1, lat2, lon2){
  #https://www.movable-type.co.uk/scripts/latlong.html
  
  r <- 6371e3 
  tetha1 <- lat1 * pi/180
  tetha2 <- lat2 * pi/180
  delta_tetha <- (lat2-lat1) * pi/180;
  delta_lambda <- (lon2-lon1) * pi/180;
  
  a <- sin(delta_tetha/2) * sin(delta_tetha/2) +
    cos(tetha1) * cos(tetha2) *
    sin(delta_lambda/2) * sin(delta_lambda/2);
  
  c <- 2 * atan2(sqrt(a), sqrt(1-a));
  
  d <- r * c
  
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
    mutate(LAT_prev = dplyr::lag(LAT), LON_prev = dplyr::lag(LON)) %>%
    mutate(distance = haversine_dist(LAT_prev, LON_prev, LAT, LON))
  
  #find most recent observation with longest distance
  longest_index <- which(observations$distance == max(observations$distance, na.rm = TRUE))[1]
  
  
  #Return the observation along with prior observation
  observations[c(longest_index-1,longest_index),] %>% arrange(DATETIME)
}


#returns the distance traveled between two observations of interest
get_dist_traveled <- function(observations_longest){
  observations_longest$distance[2]
}

get_destination <- function(observations_longest){
  observations_longest$DESTINATION[2]
}


get_start_datetime <- function(observations_longest){
  observations_longest$DATETIME[1]
}


get_end_datetime <- function(observations_longest){
  observations_longest$DATETIME[2]
}


get_journey_time <- function(observations_longest){
  
  start <- as_datetime(observations_longest$DATETIME[1])
  end  <- as_datetime(observations_longest$DATETIME[2])
  time_interval <- start %--% end
  duration_seconds <- as.duration(time_interval)
  
  as.period(duration_seconds)
  
}


get_average_speed <- function(observations_longest){
  observations_longest$SPEED[2]
}


get_course <- function(observations_longest){
  observations_longest$COURSE[2]
}



