library(shiny)
library(shinyIncubator)

shinyServer(function(input, output, session) {
  
  source("profile_plot.R")
  load("test.Rdata")

  output$distPlot <- renderPlot({
    if(input$selection == "raw") {
      plot_data <- as.matrix(obatch[,1:36])
    } else if(input$selection == "normalised") {
      plot_data <- as.matrix(eset.spike[,1:36])
    } 
    
    if(input$sep == "Yes"){
      enable <- TRUE
    } else if(input$sep == "No"){
      enable <- FALSE
    }
    
    if(input$raw_probes | input$normal_probes){}
    
    if(input$selection == "raw") {
      isolate({
        withProgress(session, {
          setProgress(message = "Processing Profile...")
          load("test.Rdata")
          plot_profile(plot_data[1:input$raw_probes,], treatments = treatment, sep=enable)
        })
      })
    } else {
      isolate({
        withProgress(session, {
          setProgress(message = "Processing Profile...")
          load("test.Rdata")
          plot_profile(plot_data[1:input$normal_probes,], treatments = treatment, sep=enable)
        })
      })
    }    
       
  })
})




