#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(tidyverse)


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
                            menuItem(tabName = "tree", "Ensemble Model", icon = icon("tablet")),
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
                                               h1("Data Description"),
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
                                                      great interest in these systems due to their important role in traffic, environmental and health issues.",
                                                      
                                                      "In this shiny app, we will focus on the records of students' math grades 
                                                from two schools and then discuss the record of language grade in the future. 
                                                There are 33 variables in total from the dataset above: 
                                                32 predictive attributes and 1 goal field, 
                                                which can be viewed in detail on the last page 'Data Page'. "),
                                                   h4("Among these 32 predictors, it has found the first grade(G1) and the second grade(G2) 
                                                contribute more to the target, the final grade(G3) than other 30 variables and thus
                                                we specifically focus on these two grades in our final grade analysis.
                                                Detailed analysis pages are listed on the left navigation. ")
                                                   
                                               )),
                                        
                                        column(6, 
                                               # Ability of the APP
                                               h1("Ability of the APP"),
                                               # Box to contain the ability of this app
                                               box(background = "blue", width = 12,
                                                   h4("The control for this app is located on the left and the visualizations are given on the right. "),
                                                   h4("In the 'Data Exploration' page, a scatter plot has been made to 
                                                visualize the relationship between the first and second grades for students from two school.
                                                You can see the different plots and values by choosing different schools and 
                                                save the scatter plot by clicking the download button at the bottom of this page"),
                                                   h4("In the 'Unsupervised Learning' page, a PCA method is utilized to see 
                                                the linear combinations of those variables. 
                                                And you can see a biplot, a screeplot and 
                                                plots of Proportion of Variance Explained and Cum. Prop of Variance Explained respetively 
                                                by clicking different tabs."),
                                                   h4("In the 'Multiple Linear Regression' page, you can see predict the final grade after inputting 
                                                the values of the first grade and the second grade. Details have beed discussed during this page"),
                                                   h4("In the 'Ensemble Model', we have compared two different tree models - knn and random forest, 
                                                for some variables. You can choose to input variables you would like to explore in this page"), 
                                                   h4("In the 'Data Information' page, you can scroll through the whole dataset and 
                                                also search for data you are interested in."),
                                                   h4("The code for this shiny app can be access from my", 
                                                      a("github page", 
                                                        href = "https://github.com/jiangyu1208/ST558-Summer20-Project-3"), ".")
                                                   
                                               )))),
                            ####################################"Data Exploration" tab####################################
                            
                            tabItem(tabName = "data",
                                    fluidPage(
                                        # Application title
                                        titlePanel("Data Exploration for Different Weather"),
                                        
                            
                            
                            
                        )
                    )
)