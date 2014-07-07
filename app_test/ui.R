library(shiny)
library(shinyIncubator)

shinyUI(fluidPage(
  fluidRow(
    headerPanel('Test Page')
  ),
  fluidRow(
    plotOutput('plot')
  ),
  fluidRow(
    wellPanel(
      uiOutput("checkbGroups"),
      tags$style(type="text/css", HTML("#foo>*{float: left; margin-right: 15px; height: 20px;} #foo {height: 50px;}"))
    )
  )
))