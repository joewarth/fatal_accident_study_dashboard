# globals.R

library(shiny)
library(shinydashboard)
library(data.table)
library(DT)
library(markdown)
library(xgboost)
library(ggplot2)

# ---- Parameters ------------------------------------------------------
param_model_path <- "model/outXgbLogistic.RDS"
param_pp_yeoj_path <- "model/pp_yeoj.RDS"
param_pp_median <- "model/pp_median.RDS"
param_pp_qual <- "model/dummyModel.RDS"

# ---- Import model ----------------------------------------------------
model <- readRDS(param_model_path)
pp_yeoj <- readRDS(param_pp_yeoj_path)
pp_median <- readRDS(param_pp_median)
pp_qual <- readRDS(param_pp_qual)

# ---- Field Lists -----------------------------------------------------
WEATHER_CHOICES <- c(
  "Clear",
  "Cloudy",
  "Fog or Dust",
  "Rain",
  "Sleet, Snow & Hail"
)

LGT_COND_CHOICES <- c(
  "Dark- Lit",
  "Dark- Not Lit",
  "Dawn or Dusk",
  "Daylight"
)

REG_STATE_CHOICE <- c(
  "Texas",
  "Alabama",
  "Alaska",
  "American Samoa",
  "Arizona",
  "Arkansas",
  "California",
  "Colorado",
  "Connecticut",
  "Delaware",
  "District of Columbia",
  "Florida",
  "Georgia",
  "Guam",
  "Hawaii",
  "Idaho",
  "Illinois",
  "Indiana",
  "Iowa",
  "Kansas",
  "Kentucky",
  "Louisiana",
  "Maine",
  "Maryland",
  "Massachusetts",
  "Michigan",
  "Minnesota",
  "Mississippi",
  "Missouri",
  "Montana",
  "Nebraska",
  "Nevada",
  "New Hampshire",
  "New Jersey",
  "New Mexico",
  "New York",
  "North Carolina",
  "North Dakota",
  "Ohio",
  "Oklahoma",
  "Oregon",
  "Pennsylvania",
  "Puerto Rico",
  "Rhode Island",
  "South Carolina",
  "South Dakota",
  "Tennessee",
  "Utah",
  "Vermont",
  "Virginia",
  "Virgin Islands",
  "Washington",
  "West Virginia",
  "Wisconsin" ,
  "Wyoming",
  "No Registration",
  "Other Special Registration"
)

OWNER_CHOICES <- c(
  "Driver Was Registered Owner",
  "Business or Govt Owned",
  "Driver Was Not Registered Owner",
  "Driverless Vehicle",
  "Rental Vehicle",
  "Vehicle Not Registered",
  "Vehicle Stolen"
)

BODY_TYP_CHOICES <- c(
  "Sedan/Coupe/Hatchback/Sation Wagon",
  "Light Pickup Truck",
  "Medium-Heavy Pickup Truck",
  "Truck Tractor",
  "Bus",
  "Motorcycles & Other Recreational Vehicles",
  "Farm/Construction Equipment",
  "Camper/Motorhome",
  "Large Limousine"
)

DEFORMED_CHOICES <- c(
  "None",
  "Minor",
  "Moderate",
  "Severe"
)

SEX_CHOICES <- c(
  "Male",
  "Female"
)

PERSON_TYPE_CHOICES <- c(
  "Pedestrian (No Vehicle)",
  "Driver (Moving Vehicle)",
  "Passenger (Moving Vehicle)",
  "Occupant (Non-moving Vehicle)"
)

POSITION_SIDE_CHOICES <- c(
  "Driver Side",
  "Passenger Side",
  "Middle & Other"
)

shiny::runApp(".")