library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
  progressInit(),
  plotOutput('plot'),

  hr(),
  
  fluidRow(
    column(3,
           h3("Profile Plot"),
           hr(), br(),
           sliderInput("percentile", 
                       label = "Percentile Range:",
                       min = 1, max = 100, value = c(1, 5))
           
    ),
    column(4, offset = 1,
           selectInput("dataset", "Choose a dataset:", 
                       choices = data_names),    
           br(),
           selectInput("sep", "Separate by Treatment?:",
                       choices = c("Yes", "No"))
    ),
    column(4,
           span("Number of probes selected:",
                         textOutput("n_probes")),
           br(),
           downloadButton('downloadData', 'Download Data Set'),
           downloadButton('downloadRangeData', 'Download Current Range'),
           downloadButton('downloadPlot', 'Download Plot') 
    )
  ),
  hr()
))