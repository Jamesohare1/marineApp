#Function to calculate distance given two sets of coordinates (lat, lon)
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