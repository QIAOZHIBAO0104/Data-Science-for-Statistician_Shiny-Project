
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
#For the Data Exploration page: creating summary data, using the "var" outputId that I created in my UI file. 
shinyServer(function(input, output) {
bikeReact <- reactive ({
  newData1 <- bike%>% select(input$var)
})

output$summary <- renderPrint(
  summary(bikeReact())
)

output$ggpairs <- renderPlot({
   ggpairs(bikeReact())
  
})


})
