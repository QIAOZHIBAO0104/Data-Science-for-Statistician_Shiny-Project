#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
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



bike <- bike %>% select(-c("instant","dteday"))
train <- sample(1:nrow(bike), size=nrow(bike)*0.8)
test <- (1:nrow(bike))[-train]
bikeTrain <- bike[train,]
bikeTest <- bike[test,]

lm.fit <- lm(cnt ~  season + weathersit + windspeed + atemp, data=bikeTrain)

optimal_model<- step(lm.fit, direction="both")

shinyServer(function(input, output) {

    output$results <- renderText({ 
        input$actionButton
        isolate({
            newdata = data.frame(season=input$season, weathersit=input$weather,windspeed=input$windspeed,atemp=input$atemp)
            final  <- predict(optimal_model, newdata , interval = "predict")
        })
    })
    # Generate a summary of the data
    output$summary <- renderPrint({
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

})
