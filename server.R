# load the packages

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
bike <- select(bike,-c("instant","dteday"))

train <- sample(1:nrow(bike), size=nrow(bike)*0.8)
test <- (1:nrow(bike))[-train]
bikeTrain <- bike[train,]
bikeTest <- bike[test,]

lm.fit <- lm(cnt ~  season + weathersit + windspeed + atemp, data=bikeTrain)

optimal_model<- step(lm.fit, direction="both")


# Shiny Part
shinyServer(function(input, output, session) { 
  
  output$mlr1 <- renderUI({
    helpText(withMathJax("MLR:$$Y=\\beta_0 +\\beta_1x_1+\\beta_2x_2+....+\\epsilon$$"))
  })
  
  ##################################### Data Exploration ######################################################    
  # Create new variables
  
  bikeReact <- reactive ({
    newData1 <- bike%>% select(input$var)
    newData1
  })
  
  output$summary1 <- renderPrint(
    summary(bikeReact())
  )
  
  output$ggpairs <- renderPlot({
    ggpairs(bikeReact())
    
  })
  
  ########################################## PCA ###############################################
  
  
  newVar2 <-reactive({
    bike[c(input$var1,input$var2)] 
  })
  
  output$tab3_result1 <- renderPrint({
    
    prcomp(bike,center=TRUE, scale=TRUE)
  })
  
  output$screeplot <- renderPlot({
    
    pca <-prcomp(bike,center=TRUE, scale=TRUE)
    screeplot(pca, type="lines")
  })
  
  output$biplot <- renderPlot(
    {
      x <- newVar2()
      dat <- princomp(x)
      biplot(dat)
    })
  
  output$plot2 <- renderPlot({
    x <- newVar2()
    dat <- princomp(x)
    par(mfrow = c(1, 2))
    plot(dat$sdev^2/sum(dat$sdev^2), xlab = "Principal Component", 
         ylab = "Proportion of Variance Explained", ylim = c(0, 1), type = 'b')
    plot(cumsum(dat$sdev^2/sum(dat$sdev^2)), xlab = "Principal Component", 
         ylab = "Cum. Prop of Variance Explained", ylim = c(0, 1), type = 'b')
  })
  
  ########################################## mlr ###############################################
  
  
  output$results <- renderText({ 
    input$actionButton
    isolate({
      newdata = data.frame(season=input$Season, weathersit=input$weather,windspeed=input$windspeed,atemp=input$atemp)
      final  <- predict(optimal_model, newdata , interval = "predict")
    })
  })
  # Generate a summary of the data
  output$summary2 <- renderPrint({
    summary(bike)
  })
  
  # Generate diagnostic plot s
  output$diagnosticplot <- renderPlot({
    
    # optional 4 graphs/page
    layout(matrix(c(1,2,3,4), 2, 2, byrow=T))
    plot(optimal_model)
    
  })
  
  # Download the plot
  output$download_plot <- downloadHandler(
    filename = "Diagnostic Plots.png",
    content = function(file){
      png(file)
      myplot()
      dev.off()
    }
  )
  
  ################################ RF Model##################################################
  RF <- reactive({
    rf <-randomForest(cnt~ .,
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
      season=input$season,
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
  
  ##################################### Data Subset #####################################################        
  bikeReact <- reactive ({
    newData5 <- bike[input$var5] 
  })
  output$bikesTable <- renderDataTable(
    bikeReact(),
    options=list(scrollX=TRUE))
  output$downloadData <- downloadHandler(
    filename="bikeData.csv",
    content=function(file){
      write.csv(bikeReact(), file, row.names=FALSE)
    })
  
})
  