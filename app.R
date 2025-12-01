# app.R
library(shiny)
library(shinydashboard)
library(data.table)
library(DT)
library(xgboost)
library(ggplot2)

source("globals.R")
source("ui.R")      # should create an object called `ui`
source("server.R")  # should create a function called `server`

shinyApp(ui = ui, server = server)