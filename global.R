#libraries
library(shiny)
library(shiny.semantic)
library(leaflet)
library(dplyr)
library(readr)
library(stringr)
library(purrr)
library(lubridate)
library(ggplot2)


#source the dropdown module and helper function file
source("~/GitHub/marineApp/dropdown.R")
source("~/GitHub/marineApp/helperFunctions.R")

# read in the data
ships <- read_csv("~/GitHub/marineApp/data/ships.csv")
