library(shiny)
library(shinyIncubator)

shinyUI(pageWithSidebar(
  headerPanel('Profile Plot'),
  sidebarPanel(
#     wellPanel(
    selectInput("dataset", "Choose a dataset:", 
                choices = c("Raw Data", "Normalised Data - Pre QC")),
    
    selectInput("sep", "Separate by Treatment?:",
                choices = c("Yes", "No")),
    
    selectInput("unit", "Unit:",
                choices = c("Percentile", "Absolute")),
    
    
    wellPanel( 
      conditionalPanel(
        condition = "input.unit == 'Percentile'",
        sliderInput("percentile", 
                    label = "Percentile Range:",
                    min = 1, max = 100, value = c(1, 5))
      ),
      
      conditionalPanel(
        condition = "input.unit == 'Absolute'",
        conditionalPanel(
          condition = "input.dataset == 'Normalised Data - Pre QC'",
          sliderInput("probes_normalisedI",
                      "Probes:",
                      min = 1,
                      max = length(eset.spike[,1]),
                      value = 50)
        ),
        
        conditionalPanel(
          condition = "input.dataset == 'Raw Data'",
          sliderInput("probes_raw",
                      "Probes:",
                      min = 1,
                      max = length(obatch[,1]),
                      value = 50)
        )
      )
    )
  ),

  mainPanel(
    plotOutput('plot'), 
    wellPanel(
      downloadButton('downloadData', 'Download Data Set'),
      downloadButton('downloadRangeData', 'Download Current Range'),
      downloadButton('downloadPlot', 'Download Plot')
    )
  )
))

# conditionalPanel(
#   condition = "input.unit == 'Absolute'",
#   conditionalPanel(
#     condition = "input.dataset == 'Normalised Data'",
#     sliderInput("probes",
#                 "Probes:",
#                 min = 1,
#                 max = length(eset.spike[,1]),
#                 value = 30)
#   ),
#   conditionalPanel(
#     condition = "input.dataset == 'Raw Data'",
#     sliderInput("probes",
#                 "Probes:",
#                 min = 1,
#                 max = length(obatch[,1]),
#                 value = 30)
#   )
# )
# 
# conditionalPanel(
#   condition = "input.plotType == 'hist'",
#   selectInput(
#     "breaks", "Breaks",
#     c("Sturges",
#       "Scott",
#       "Freedman-Diaconis",
#       "[Custom]" = "custom")),
#   
#   # Only show this panel if Custom is selected
#   conditionalPanel(
#     condition = "input.breaks == 'custom'",
#     sliderInput("breakCount", "Break Count", min=1, max=1000, value=10)
#   )
# )