#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shiny)
library(tidyverse)
library(shinydashboard)
library(graphics)
# Read the Data
bike <-read.csv("day.csv",header=T)

bike$weather <-ifelse(bike$weathersit==1,"Few Clouds",ifelse(bike$weathersit==2,"Mist","Light Snow")) 
bike$Season <- ifelse(bike$season==1,"Spring",ifelse(bike$season==2,"Summer",ifelse(bike$season==3,"Fall","Winter")))
bike$Workingday <- ifelse(bike$workingday==1,"Yes","No")
bike %>% select(-c("instant","dteday"))

train <- sample(1:nrow(bike), size=nrow(bike)*0.8)
test <- (1:nrow(bike))[-train]
bikeTrain <- bike[train,]
bikeTest <- bike[test,]

tabItem(tabName = "mlr",
        pageWithSidebar(
            # Application title
            headerPanel("Linear Regression Analysis"),
            # Adding widgets
            sidebarPanel(
                h4("Help text"),
                helpText("Enter Season Weather,Windspeed and Ambient Temperature,
             click on ",strong("Predict!")," to get predicted value of Casual & Registered Users."),
                sliderInput("season", label = "Season", 
                            value = 10, min = 1, max = 4, animate = FALSE),
                sliderInput("weather", label = "Weather Condition", 
                            value = 10, min = 1, max = 3, animate = FALSE),
                sliderInput("windspeed", label = "Windspeed", 
                            value = 10, min = 0.02239, max = 0.50746, animate = FALSE),
              sliderInput("atemp", label = "Ambient Temperature", 
                          value = 10,min =  0.07907, max = 0.84090, animate = FALSE),
              
              actionButton("actionButton","Predict!",align = "center"),
        ),
        
        # Show a plot of the generated distribution
        mainPanel(
            tabsetPanel(
                tabPanel("Prediction",
                         h2("Multiple Regression Predction ",align="center"),
                         p("We will apply a multiple linear regression model to predict the number of Casual & Registered Users."),
                           p("A multiple linear regression (MLR) model that describes a ",
                           strong("dependent variable y by independent variables x1, x2, ..., xp with error.")), 
                         
                         p("For example, the dataset from UCI Machine Learning Repository",
                           strong("Bike Sharing")," 
               from count of total rental bikes including both casual and registered in Bike sharing systems.",
                           strong("lm")," is 
                 ", strong("used to fit a linear model to make prediction on the response variable.")," 
                 Chose the optimal model by",
                           strong("AIC in a stepwise Algorithm."),
                           "The obtained model has 4 independent variables."),
                         
                         p("We now apply the predict function and 
                 set the predictor variables in the newdata argument. 
                 We also set the interval type as",
                           strong("predict")," and use",
                           strong(" the default 0.95 confidence level")),
                         
                         p("The predicted",span("number of Casual & Registered Users",style = "color:blue")," 
                 and its",span(" Lower Bound",style="color:blue"),"and",
                           span("Upper Bound",style="color:blue")," values are :"),
                         code(textOutput("results"))
                         ),
                
                tabPanel("Summary", 
                         h2("Summary of",strong("bike sharing"),"dataset"),
                         p("The variable",strong('instant'),"and",strong('dteday'),"are removed"),
                         verbatimTextOutput("summary")
                         ),
                
                tabPanel("Diagnostic Plots" ,
                         p("Residuals vs Fitted plot checks for heteroscedasticity"),
                         p("Q-Q plot checks for normality"),
                         p("Scale-Location plot checks for a constant variance"),
                         p("Residuals vs Leverage checks for influential observations"),
                         plotOutput("diagnosticplot"),
                downloadButton("download_plot", "Save the Plot"))
                
                
                
                
        ))
))