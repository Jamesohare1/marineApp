#libraries
library(shiny)
library(shiny.semantic)
library(leaflet)
library(dplyr)
library(readr)
library(stringr)
library(purrr)
library(lubridate)

#source the dropdown module and helper function file
source("dropdown.R")
source("utils.R")
source("infoModalContent.R")

# read in the data
ships <- read_csv("data/ships.csv")

ship_types <- get_ship_types(ships)
default_ship_names <- ships %>% filter(ship_type == "Passenger") %>%
  select(SHIPNAME) %>%
  unique() %>%
  pull() %>%
  sort()

