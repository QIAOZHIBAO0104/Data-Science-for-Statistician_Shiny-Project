
# Load up all packages
library(shiny)
library(tidyverse)

Bike <- read.csv("day.csv")

# Define server logic required to draw a histogram
shinyServer(function(input, output,session) {
         
    new_var1 <- reactive({
        new_bike1 <- Bike %>% filter(wetherfit==input$var)
        
    })
    



})
