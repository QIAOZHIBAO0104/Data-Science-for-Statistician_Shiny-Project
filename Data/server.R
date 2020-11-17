#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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

shinyServer(function(input, output) {
  bike$weather <-ifelse(bike$weathersit==1,"Few Clouds",ifelse(bike$weathersit==2,"Mist","Light Snow")) 
  bike$Season <- ifelse(bike$season==1,"Spring",ifelse(bike$season==2,"Summer",ifelse(bike$season==3,"Fall","Winter")))
  bike$Workingday <- ifelse(bike$workingday==1,"Yes","No")

  bikeReact5 <- reactive ({
    newData5 <- bike[input$var5] 
  })
  output$bikesTable <- renderDataTable(
    bikeReact5(),
    options=list(scrollX=TRUE))
  output$downloadData <- downloadHandler(
    filename="bikeData.csv",
    content=function(file){
      write.csv(bikeReact5(), file, row.names=FALSE)
    })
})


