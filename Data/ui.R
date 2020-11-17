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

bike <-read.csv("day.csv",header=T)
bike <- select(bike,-c("instant","dteday"))

tabItem(tabName="data",
        pageWithSidebar(
        titlePanel("Bike Data"),
          sidebarPanel(
            selectizeInput("var5", 
                           label="Select Variables of Interest:", 
                           multiple=TRUE,
                           selected=names(bike),
                           choices=c("Season"="season", 
                                     "Season Description"="Season",
                                     "Year"="yr", 
                                     "Month"="mnth",
                                     "Holiday"="holiday",
                                     "Weekday"="weekday",
                                     "Working Day"="workingday",
                                     "Workingday"="Workingday",
                                     "Weather"="weather",
                                     "Weather Condition"="weathersit",
                                     "Temperature"="temp",
                                     "Ambient Temperature"="atemp",
                                     "Humidity"="hum",
                                     "Windspeed"="windspeed",
                                     "Casual Users"="casual",
                                     "Registered Users"="registered",
                                     "Casual & Registered Users"="cnt"), 
                           options=list(create=TRUE, placeholder="Click to see dropdown list.")),
            p("To view a subset of the data, click on the variable(s) you wish to remove and hit delete or backspace."),
            br(), br(),
            conditionalPanel(condition="input.var4==0", 
                             p(h4("Users need to specify at least one variable to show the data"))),
            downloadButton("downloadData", "Download Data for Selected Variables")
          ),
          
          mainPanel(
            dataTableOutput("bikesTable", width="600px")
          )
        )
)
