library(shiny)
library(shinyIncubator)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  progressInit(),
  
  # Application title
  titlePanel("Profile Plot"),
  
  helpText("View Probe intensities across samples"),
  
  # Sidebar with a slider input for the number of bins
  sidebarLayout(
    sidebarPanel(
      
      sliderInput("raw_probes",
                  "Raw Data:",
                  min = 1,
                  max = 15840,
                  value = 30),
      
      sliderInput("normal_probes",
                  "Normalised Data:",
                  min = 1,
                  max = 3540,
                  value = 30),
      
      selectInput("selection", "Choose a dataset:", 
                   choices=c('raw', 'normalised')),
      
      checkboxGroupInput('sep', 'Separate by treatment?:',
                           c("Yes", "No"), selected = "No")
      
#       uiOutput("slider")
    ),

    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("distPlot")
    )
  )
))
