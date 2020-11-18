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
# Define server logic required to draw a histogram
shinyServer(function(input, output) {

  #Creating a Random Forest model, along with a training and test set for this and the Bagged Trees model. 
  train <- sample(1:nrow(bike), size=nrow(bike)*0.8)
  test <- (1:nrow(bike))[-train]
  bikeTrain <- bike[train,]
  bikeTest <- bike[test,]
  
  RF <- reactive({
    rf <-randomForest(cnt~.,
                 data=bikeTrain,
                 ntree=input$Ntree,
                 mtry=3,
                 importance=TRUE, 
                 replace=FALSE)
    rf
  })
  output$imp.plot <- renderPlot({
    varImpPlot(RF(),main = "Variable Importance")})
  
  
  
  bikeReact3 <- reactive({
    newData3 <- data.frame(
      season=input$seas,
      yr=input$yr,
      mnth=input$mnth,
      holiday=input$holiday,
      weekday=input$weekday,
      workingday=input$workingday,
      weathersit=input$weathersit,
      temp=input$temp,
      atemp=input$atemp,
      hum=input$hum,
      windspeed=input$windspeed,
      casual=input$casual,
      registered=input$registered)
  })
  
  predictionRf <- reactive({
    round(predict(RF(), bikeReact3()),0)
  })
  output$prediction <- renderText(predictionRf())
  

})
