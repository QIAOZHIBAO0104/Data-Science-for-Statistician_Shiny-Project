#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)

# Read the Data
bike <-read.csv("day.csv",header=T)

bike$weather <-ifelse(bike$weathersit==1,"Few Clouds",ifelse(bike$weathersit==2,"Mist","Light Snow")) 
bike$Season <- ifelse(bike$season==1,"Spring",ifelse(bike$season==2,"Summer",ifelse(bike$season==3,"Fall","Winter")))
bike$Workingday <- ifelse(bike$workingday==1,"Yes","No")
bike <- select(bike,-c("instant","dteday"))

# UI Part
shinyUI(fluidPage(
            # Application title
            titlePanel("Data Exploration for Bike Sharing"),
           
           

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Select the Season:"),
            selectizeInput("season", "Season", 
                           choices = c("Spring"="Spring",
                                       "Summer"="Summer",
                                       "Fall"="Fall",
                                       "Winter"="Winter")
            ),
            
            sliderInput("size", "Size of Points on Graph",
                        min = 1, max = 10, value = 5, step = 1, animate = TRUE),
            
            checkboxInput("weather", h4("Color Code Weather Status", style = "color:blue;")),
            
            # Use a conditionalPanel to create box that required
            
            conditionalPanel(
              condition = "input.weather",
              checkboxInput("workingday","Also change symbol based on Workingday?")
            )
        ),

        # Show a plot of the generated distribution
        mainPanel(
          plotOutput("bikePlot"),
          textOutput("info"),
          tableOutput("table")
        )
    )
))
