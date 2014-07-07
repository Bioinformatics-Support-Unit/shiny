library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
  progressInit(),
  
  navbarPage(
    title = 'Differential Expression',
    tabPanel('Config',
             fluidRow(
               column(3,
                      h3("Controls")
#                       downloadButton('downloadPlot', 'Download Plot')      
               ),
               column(3,
                      selectInput("dataset", "Choose a dataset:", 
                                  choices = c("Co - Ly", "Co - Hi", "Co - Lo", "Hi - Ly", 
                                              "Hi - Lo", "Ly - Lo", "Co - Sj", "Ly - Sj"))#,
#                       selectInput("comparison", "Choose a comparison:", 
#                                   choices = comp_in)
               ),
               column(3,
                      br(),
                      numericInput("pval", label = h5("Adjusted P Value Cutoff"), value = 0.05, step=0.01),
                      numericInput("fc", label = h5("Fold Change"), value = 1.2, step=0.01)
               )
             )
    ), 
    tabPanel('Volcano Plot',              ggvisOutput("plot1")),
    tabPanel('Filtered Gene List',        dataTableOutput(outputId = 'filtered')),
    tabPanel('Unfiltered Gene List',      dataTableOutput(outputId = 'unfiltered'))
  ),

  hr()
))