#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(shinydashboard)
library(graphics)

# Read the Data
bike <-read.csv("day.csv",header=T)

bike$weather <-ifelse(bike$weathersit==1,"Few Clouds",ifelse(bike$weathersit==2,"Mist","Light Snow")) 
bike$Season <- ifelse(bike$season==1,"Spring",ifelse(bike$season==2,"Summer",ifelse(bike$season==3,"Fall","Winter")))
bike$Workingday <- ifelse(bike$workingday==1,"Yes","No")
bike <-select(bike,-c("instant","dteday"))

# UI part
tabItem(tabName = "unsuper",
        fluidPage(
          headerPanel(h1("Principal Component Analysis")),
          
    # Sidebar with a slider input for number of bins
    sidebarLayout(
        sidebarPanel(
            selectInput("var1",
                        label="Select the First Variable for Principal Component Analysis:",
                        choices = c("Season"="season", 
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
                                    "Casual & Registered Users"="cnt"
                            )),
         
            selectInput("var2",
                        label="Select the second Variable for Principal Component Analysis:",
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
                        selected="cnt"),
            
            conditionalPanel(condition="input.var1==input.var2", 
                             em(h4("Can not select the same variable!")
                             ))
            ),
            
              mainPanel(
                tabsetPanel(
                  
                  tabPanel("PC_Scores",verbatimTextOutput("tab3_result1")),
                  tabPanel("PC_Scree_PLot",plotOutput("screeplot")),
                  tabPanel("Bi_Plot",plotOutput("biplot")),
                  tabPanel("Proportion of Variance Explained vs 
                               Cum. Proportion of Variance Explained",
                           plotOutput("plot2"))
                  
                )))
))
            
