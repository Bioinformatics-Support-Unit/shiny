library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
  progressInit(),
  
  navbarPage(
    title = 'Differential Expression',
    tabPanel('Config',
             fluidRow(
               column(3,
                      h3("Controls"),
                      downloadButton('downloadPlot', 'Download Plot')      
               ),
               column(3,
                      br(),
                      selectInput("dataset", "Choose a contrast:", 
                                  choices = c("mic - threep", "HPC - HP140")),
                      selectInput("mtc", "Apply Multiple Test Correction?",
                                  choices=c("none", "BH"))
               ),
               column(3,
                      br(),
                      numericInput("pval", label = h5("Adjusted P Value Cutoff"), value = 0.01, step=0.01),
                      numericInput("fc", label = h5("Fold Change"), value = 1.5, step=0.01),
                      br(),br(),br()
               )
             )
    ), 
    tabPanel('Volcano Plot',              ggvisOutput("plot1")),
    tabPanel('Filtered Gene List',        dataTableOutput(outputId = 'filtered')),
    tabPanel('Unfiltered Gene List',      dataTableOutput(outputId = 'unfiltered')),
    tabPanel('miRNA Targets',             dataTableOutput(outputId = 'mirna_targets')),
    tabPanel('Common Targets',            dataTableOutput(outputId = 'mirna_targets_int'))
  ),

  hr()
))