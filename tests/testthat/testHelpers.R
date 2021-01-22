source("~/GitHub/marineApp/global.R")
ship_type <- "Passenger"
ship_name <- "ADA"


#Return relevant observations for a selected ship type
test_that("correct observations are returned for a given ship type and name",{
  
  actual <- get_ship_observations(ships, ship_type, ship_name)
  expected <- read_rds("~/GitHub/marineApp/tests/testdata/observations.rds")
  
  expect_equal(actual, expected)
  
})

get_ship_observations <- function(ships, input_ship_type, input_ship_name){}




test_that("haversine distance calculates correcly",{
  
  actual <- haversine_dist(ships)
  
  expect_equal("a", "a")
  
})


#Calculate the average bearing for a journey
get_bearing <- function(observations_longest){
}


#Return relevant observations for a selected ship type
get_ship_observations <- function(ships, input_ship_type, input_ship_name){}


#Return sorted ship types
get_ship_types <- function(ships){}


#Update available ship choices depending on which ship type is selected
update_ship_choices <- function(ships, input_ship_type){}


#Return the distance traveled between two observations of interest
get_dist_traveled <- function(observations_longest){}


#Return destination
get_destination <- function(observations_longest){}


#Return the start time and date
get_start_datetime <- function(observations_longest){}


#Return the end time and date
get_end_datetime <- function(observations_longest){}


#Return the journey time
get_journey_time <- function(observations_longest){}


#Helper function to prettify Journey start and end times
tidy_dateTime <- function(dateTime){}


#Helper function to prettify the journey time
parse_timePeriod <- function(period){}


#Helper function to prettify the journey time
extract_units <- function(period, pattern){}


#Helper function to prettify the journey time
tidy_time <- function(units, text){}


#Calculate the average speed for a journey
get_average_speed <- function(observations_longest){}

draw_arrow <- function(observations_longest){}

