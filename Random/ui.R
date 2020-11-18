#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(randomForest)
library(tidyverse)
library(shinydashboard)
library(graphics)
library(DT)
library(plotly)
library(caret)

tabItem(tabName="RFmodeling",
        pageWithSidebar(
          
          headerPanel("Random Forest Model"),
          sidebarPanel(
            numericInput("Ntree","Select the number of trees to include in the model:", min=1, value=1),
            h4("Select Variable Values for Prediction"),
            selectInput("seas", "Season", choices=(c("Winter"="1","Spring"="2","Summer"="3","Fall"="4"))),
            selectInput("yr", "Year", choices=c("2011"="0", "2012"="1")),
            selectInput("mnth", "Month", choices=c("1","2","3","4","5","6","7","8","9","10","11","12")),
            selectInput("holiday","Holiday", choices=c("Yes"="1", "No"="0")),
            selectInput("weekday", "Weekday", choices=c("Sunday"="0","Monday"="1", "Tuesday"="2", "Wednesday"="3", "Thursday"="4", "Friday"="5", "Saturday"="6")),
            selectInput("workingday", "Working Day", choices=c("Yes"="1", "No"="0")),
            selectInput("weathersit", "Weather Condition", choices=c("Clear, few clouds..."="1", "Mist + Cloudy..."="2", "Light Snow, Light Rain + Thunderstorm..."="3", "Heavy Rain..."="4")),
            sliderInput("temp", "Temperature (Celcius, Normalized)", value=0, min=0, max=1),
            sliderInput("atemp", "Ambient Temperature (Celcius, Normalized)", value=0, min=0, max=1),
            sliderInput("hum", "Humidity (Normalized)", value=0, min=0, max=1),
            sliderInput("windspeed", "Windspeed (Normalized)", value=0, min=0, max=1),
            numericInput("casual", "Casual Users", value=0),
            numericInput("registered", "Registered Users", value=0)
          ),
          mainPanel(
            tabsetPanel(
            tabPanel("Prediction",
                     p("Users can specify their selection, the predicted anticipated number of both casual and registered bike users for a day is approximately:"),
                     textOutput("prediction")),
            
            tabPanel("Importance Plot",
                     p("Plots the importance measures"),
                     plotOutput("imp.plot"))
            
            
          )
        )
))