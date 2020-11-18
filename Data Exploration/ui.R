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


# UI Part
shinyUI(fluidPage(
            # Application title
            titlePanel("Data Exploration for Bike Sharing"),
           
           

    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            h3("Select the Season:"),
            selectizeInput("season", "Season", 
                           choices = c("Spring"="1",
                                       "Summer"="2",
                                       "Fall"="3",
                                       "Winter"="4")
            ),
            
            sliderInput("size", "Size of Points on Graph",
                        min = 1, max = 10, value = 5, step = 1, animate = TRUE),
            
            checkboxInput("weathersit", h4("Color Code Weather Status", style = "color:blue;")),
            
            # Use a conditionalPanel to create box that required
            
            conditionalPanel(
              condition = "input.weathersit",
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
