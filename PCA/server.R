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


# Define server logic required to draw a histogram
shinyServer(function(input, output,session){

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
        biplot(dat, xlabs = rep(".", nrow(bike)), cex = 1.2)
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
  

    })

