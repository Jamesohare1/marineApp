#libraries
library(shiny)
library(shiny.semantic)
library(leaflet)
library(dplyr)

#source the dropdown module and helper function file
source("~/GitHub/marineApp/dropdown.R")
source("~/GitHub/marineApp/helper.R")

# read in the data
ships <- read.csv("~/GitHub/marineApp/data/ships.csv")

