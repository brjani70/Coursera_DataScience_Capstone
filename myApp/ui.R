library(shiny)
library(markdown)

setwd("C:/Users/brjani70/Desktop/Coursera R/final/finalcode")

## SHINY UI
shinyUI(
  fluidPage(
    titlePanel("Coursera Specialization: Data Science - Capstone Project - Word Predictions using Natural Language Processing"),
    sidebarLayout(
      sidebarPanel(
        helpText("Please enter a word or phrase below to activate the prediction algorithm:"),
        hr(),
        textInput("inputText", "Please enter your input here:",value = ""),
        hr(),
        hr(),
        hr()
      ),
      mainPanel(
        h2("Below find the algorithm's prediction based on your input:"),
        verbatimTextOutput("prediction"),
        strong("User input:"),
        strong(code(textOutput('sentence1'))),
        br(),
        strong("How is the algorithm coming up with that prediction? See below:"),
        strong(code(textOutput('sentence2'))),
        hr(),
        img(src = "coursera_logo.png", height = 122, width = 467),
        hr()
      )
    )
  )
)