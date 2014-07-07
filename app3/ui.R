library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
  progressInit(),

  plotOutput('plot'),

  fluidRow(
      hr(),
      h3("Principal Component Analysis"),
      uiOutput("checkbGroups"),
      tags$style(type="text/css", HTML(".checkbox {margin-left: 15px; height: 20px;} #foo>*{float:left;}"
      ))
  )
))