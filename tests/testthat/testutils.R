library(shiny)
library(dplyr)
library(readr)
library(stringr)
library(purrr)
library(lubridate)
source("../../utils.R")

ships <- read_csv("../../data/ships.csv")
ship_type <- "Passenger"
ship_name <- "ADA"
observations <- get_ship_observations(ships, ship_type, ship_name)

test_that("correct observations are returned for a given ship type and name",{
  
  actual <- observations
  expected <- read_rds("../testdata/observations.rds")
  
  expect_equal(actual, expected)
})

test_that("haversine distance calculates correctly",{
  
  lat1 <- ships$LAT
  lon1 <- ships$LON
  lat2 <- dplyr::lead(ships$LAT)
  lon2 <- dplyr::lead(ships$LON)
  
  actual <- haversine_dist(lat1, lon1, lat2, lon2)
  expected <- read_rds("../testdata/distance.rds")
  
  expect_equal(actual, expected)
})


test_that("bearing calculates correctly",{
  
  lat1 <- ships$LAT
  lon1 <- ships$LON
  lat2 <- dplyr::lead(ships$LAT)
  lon2 <- dplyr::lead(ships$LON)
  
  actual <-get_bearing(observations)
  expected <- read_rds("../testdata/bearing.rds")
  
  expect_equal(actual, expected)
})

test_that("ship types are being filtered correctly",{
  
  actual <- get_ship_types(ships)
  expected <- read_rds("../testdata/shipTypes.rds")
  
  expect_equal(actual, expected)
})

test_that("ship names are being filtered correctly",{
  
  actual <- update_ship_choices(ships, ship_type)
  expected <- read_rds("../testdata/shipNames.rds")
  
  expect_equal(actual, expected)
})

test_that("distance travelled is being returned correctly",{
  
  actual <- get_dist_traveled(observations)
  expected <- read_rds("../testdata/distTravelled.rds")
  
  expect_equal(actual, expected)
})

test_that("destination is being returned correctly",{
  
  actual <- get_destination(observations)
  expected <- read_rds("../testdata/destination.rds")
  
  expect_equal(actual, expected)
})

test_that("datetimes are being tidied and returned correctly",{
  
  actual_start <- get_start_datetime(observations)
  expected_start <- read_rds("../testdata/startDateTime.rds")
  expect_equal(actual_start, expected_start)
  
  actual_end <- get_end_datetime(observations)
  expected_end <- read_rds("../testdata/endDateTime.rds")
  expect_equal(actual_end, expected_end)
})

test_that("journey time is being tidied and returned correctly",{
  
  actual <- get_journey_time(observations)
  expected <- read_rds("../testdata/journeyTime.rds")
  
  expect_equal(actual, expected)
})

test_that("average speed is being calculated and rendered correctly",{
  
  actual <- get_average_speed(observations)
  expected <- read_rds("../testdata/averageSpeed.rds")
  
  expect_equal(actual, expected)
})
