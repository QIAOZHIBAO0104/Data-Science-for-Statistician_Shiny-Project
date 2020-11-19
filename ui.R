# load the packages

library(shiny)
library(randomForest)
library(tidyverse)
library(shinydashboard)
library(graphics)
library(DT)
library(plotly)
library(caret)

# Read the data
# Two irrealvant variables are removed
bike <-read.csv("day.csv",header=T)


# UI part
ui <- dashboardPage(skin = "blue",
                    # Add title                  
                    dashboardHeader(title = "Bike Sharing Analysis", titleWidth = 350),
                    
                    # Define sidebar items
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem(tabName = "intro", "Introduction", icon = icon("archive")),
                        menuItem(tabName = "data", "Data Exploration", icon = icon("table")),
                        menuItem(tabName = "unsuper", "Unsupervised Learning", icon = icon("th")),
                        menuItem(tabName = "mlr", "Multiple Linear Regression", icon = icon("tablet")),
                        menuItem(tabName = "RFmodel", "Random Forest Model", icon = icon("tablet")),
                        menuItem(tabName = "sub", "Data Information", icon = icon("th"))
                      )),
                    
                    # Define the body of the app
                    dashboardBody(
                      tabItems(
                        
                        ################## "Introduction" tab ############################################################################
                        tabItem(tabName = "intro",
                                fluidRow(
                                  # Add in latex function 
                                  withMathJax(),
                                  
                                  # Two columns for each of the two items
                                  column(6,
                                         # Description of data
                                         h1("Data Information"),
                                         # Box to contain the data description content
                                         box(background = "navy", width = 12,
                                             h4("The dataset is from UCI Machine Learning Repository and it can be found from", 
                                                a("this website", 
                                                  href = "https://archive.ics.uci.edu/ml/datasets/Bike+Sharing+Dataset"), "."),
                                             h4("Bike sharing systems are new generation of traditional bike rentals where whole 
                                                      process from membership, rental and return back has become automatic. Through these 
                                                      systems, user is able to easily rent a bike from a particular position and return 
                                                      back at another position. Currently, there are about over 500 bike-sharing programs 
                                                      around the world which is composed of over 500 thousands bicycles. Today, there exists 
                                                      great interest in these systems due to their important role in traffic, environmental and health issues."
                                                
                                             ),
                                             
                                         )),
                                  
                                  column(6, 
                                         # Ability of the APP
                                         h1("Project Description"),
                                         # Box to contain the ability of this app
                                         box(background = "blue", width = 12,
                                             p("The Data that I selected has different variables to influence the bike sharing users "),
                                             h4("In the 'Data Exploration' page, a scatter plot has been made to 
                                                visualize the relationship between the count of registered users and count of total rental bikes 
                                                including both casual and registered .
                                                You can see the different plots and values by choosing different predictors and 
                                                save the scatter plot by clicking the download button at the bottom of this page"),
                                             h4("In the 'Unsupervised Learning' page, a PCA method is utilized to see 
                                                the linear combinations of those variables. 
                                                And users can see PCA scores,biplot, a screeplot and 
                                                plots of Proportion of Variance Explained and Cum. Prop of Variance Explained respetively 
                                                by clicking different tabs."),
                                             h4("In the 'Multiple Linear Regression' page, users can make predictions by specifying the variables they want"),
                                             h4("In the 'Random Forest Model', Users are able to make predictions and check the importance of variable"), 
                                             h4("In the 'Data Information' page, users can subset the variables they are interested in")
                                             
                                             
                                         )))),
                        ####################################"Data Exploration" tab####################################
                        tabItem(tabName="data",
                                fluidPage(
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
                                    p("Users can add or remove the variable here by click the box"),
                                    
                                    
                                  ),
                                  
                                  mainPanel(
                                    tabsetPanel(
                                      tabPanel("Summary Data", verbatimTextOutput("summary1")),
                                      tabPanel("Correlation plots of Individual Variables", plotOutput("ggpairs")),
                                      downloadButton("download_plot", "Save the Plot"))
                                    
                                  ))),
                        ##########################################  "Unsupervised Learning" tab ###############################################
                        
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
                                                 plotOutput("plot2")),
                                        downloadButton("download_plot", "Save the Plot"))
                                      
                                    ))
                                )),
                        
                        ######################################## "MLR" tab ##############################################
                        
                        tabItem(tabName = "mlr",
                                pageWithSidebar(
                                  # Application title
                                  headerPanel("Linear Regression Analysis"),
                                  # Adding widgets
                                  sidebarPanel(
                                    h4("Help text"),
                                    helpText("Enter Season Weather,Windspeed and Ambient Temperature,
             click on ",strong("Predict!")," to get predicted value of Casual & Registered Users."),
                                    uiOutput("mlr1"),
                                    sliderInput("Season", label = "Season", 
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
                                               verbatimTextOutput("summary2")
                                      ),
                                      
                                      tabPanel("Diagnostic Plots" ,
                                               p("Residuals vs Fitted plot checks for heteroscedasticity"),
                                               p("Q-Q plot checks for normality"),
                                               p("Scale-Location plot checks for a constant variance"),
                                               p("Residuals vs Leverage checks for influential observations"),
                                               plotOutput("diagnosticplot"),
                                               downloadButton("download_plot", "Save the Plot"))
                                      
                                      
                                      
                                      
                                    ))
                                )),
                        ################################ "RF Model" tab ##################################################
                        tabItem(tabName="RFmodel",
                                pageWithSidebar(
                                  
                                  headerPanel("Random Forest Model"),
                                  sidebarPanel(
                                    numericInput("Ntree","Select the number of trees to include in the model:", min=1, value=1),
                                    h4("Select Variable Values for Prediction"),
                                    selectInput("season", "Season", choices=(c("Winter"="1","Spring"="2","Summer"="3","Fall"="4"))),
                                    selectInput("yr", "Year", choices=c("2011"="0", "2012"="1")),
                                    selectInput("mnth", "Month", choices=c("1","2","3","4","5","6","7","8","9","10","11","12")),
                                    selectInput("holiday","Holiday", choices=c("Yes"="1", "No"="0")),
                                    selectInput("weekday", "Weekday", choices=c("Sunday"="0","Monday"="1", "Tuesday"="2", "Wednesday"="3", "Thursday"="4", "Friday"="5", "Saturday"="6")),
                                    selectInput("workingday", "Working Day", choices=c("Yes"="1", "No"="0")),
                                    selectInput("weathersit", "Weather Condition", choices=c("Clear, few clouds..."="1", "Mist + Cloudy..."="2", "Light Snow, Light Rain + Thunderstorm..."="3", "Heavy Rain..."="4")),
                                    sliderInput("temp", "Temperature (Celcius, Normalized)", value=0, min=0, max=1),
                                    sliderInput("atemp", "Ambient Temperature (Celcius, Normalized)", value=0, min=0, max=1),
                                    sliderInput("hum", "Humidity (Normalized)", value=0, min=0, max=1),
                                    sliderInput("windspeed", "Windspeed (Normalized)", value=0, min=0, max=1),
                                    numericInput("casual", "Casual Users", value=0),
                                    numericInput("registered", "Registered Users", value=0)
                                  ),
                                  mainPanel(
                                    tabsetPanel(
                                      tabPanel("Prediction",
                                               p("Users can specify their selection, the predicted anticipated number of both casual and registered bike users for a day is approximately:"),
                                               textOutput("prediction")),
                                      
                                      tabPanel("Importance Plot",
                                               p("Plots the importance measures"),
                                               plotOutput("imp.plot")
                                      )
                                      
                                      
                                    )
                                  )
                                )),
                        
                        ##################################### Data subset tab #####################################################         
                        tabItem(tabName="sub",
                                pageWithSidebar(
                                  titlePanel("Bike Data"),
                                  sidebarPanel(
                                    selectizeInput("var5", 
                                                   label="Select Variables of Interest:", 
                                                   multiple=TRUE,
                                                   selected=names(bike),
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
                                    p("To view a subset of the data, click on the variable(s) to remove and hit to delete."),
                                    br(), br(),
                                    conditionalPanel(condition="input.var4==0", 
                                                     p(h4("Users need to specify at least one variable to show the data"))),
                                    downloadButton("downloadData", "Download Data")
                                  ),
                                  
                                  mainPanel(
                                    dataTableOutput("bikesTable", width="600px")
                                  )
                                )
                        )
                        
                        
                      ),                      
                    ))    