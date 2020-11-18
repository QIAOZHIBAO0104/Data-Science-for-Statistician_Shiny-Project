
library(shiny)
library(randomForest)
library(tidyverse)
library(shinydashboard)
library(graphics)
library(DT)
library(plotly)
library(caret)
library(ggplot2)
library(GGally)
# Read the data
# Two irrealvant variables are removed
bike <-read.csv("day.csv",header=T)

tabItem(tabName="dataExploration",
        pageWithSidebar(
        titlePanel("Data Exploration"),
        
          sidebarPanel(
            selectizeInput("var", 
                           label="Select Two or More Variables of Interest To Compare:", 
                           multiple=TRUE,
                           selected=c("temp","cnt"),
                           choices=c("Season"="season", 
                                     "Year"="yr", 
                                     "Month"="mnth",
                                     "Holiday"="holiday",
                                     "Weekday"="weekday",
                                     "Working Day"="workingday",
                                     "Weather Condition"="weathersit",
                                     "Temperature"="temp",
                                     "Ambient Temperature"="atemp",
                                     "Humidity"="hum",
                                     "Windspeed"="windspeed",
                                     "Casual Users"="casual",
                                     "Registered Users"="registered",
                                     "Casual & Registered Users"="cnt"), 
                           options=list(create=TRUE, placeholder="Click to see dropdown list.")), 
            em("Users can add or remove the variable here by click the box"),
               br(), br(),
            
            downloadButton("downloadData_dataExploration", "Download Data")
            ),
        
          mainPanel(
            tabsetPanel(
              tabPanel("Summary Data", verbatimTextOutput("summary")),
              tabPanel("Correlation plots of Individual Variables", plotOutput("ggpairs")
              )
            
          ))))