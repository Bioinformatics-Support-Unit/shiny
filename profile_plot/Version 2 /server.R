library(shiny)
library(shinyIncubator)
source("profile_plot.R")
load("test.Rdata")
# shinyServer(function(input, output, session) {
#   
# #   source("profile_plot.R")
# #   load("test.Rdata")
# 
#   output$distPlot <- renderPlot({
#     if(input$selection == "raw") {
#       plot_data <- as.matrix(obatch[,1:36])
#     } else if(input$selection == "normalised") {
#       plot_data <- as.matrix(eset.spike[,1:36])
#     } 
#     
#     if(input$sep == "Yes"){
#       enable <- TRUE
#     } else if(input$sep == "No"){
#       enable <- FALSE
#     }
#     
#     if(input$raw_probes | input$normal_probes){}
#     
#     if(input$selection == "raw") {
#       isolate({
#         withProgress(session, {
#           setProgress(message = "Processing Profile...")
#           load("test.Rdata")
#           plot_profile(plot_data[1:input$raw_probes,], treatments = treatment, sep=enable)
#         })
#       })
#     } else {
#       isolate({
#         withProgress(session, {
#           setProgress(message = "Processing Profile...")
#           load("test.Rdata")
#           plot_profile(plot_data[1:input$normal_probes,], treatments = treatment, sep=enable)
#         })
#       })
#     }    
#        
#   })
# })


shinyServer(function(input, output) {
  
#   source("profile_plot.R")
#   load("test.Rdata")
  values <- reactiveValues()
  
  datasetInput <- reactive({
    switch(input$dataset,
           "Raw Data" = obatch,
           "Normalised Data - Pre QC" = eset.spike)
  })
  
  sepInput <- reactive({
    switch(input$sep,
           "Yes" = TRUE,
           "No" = FALSE)
  })
  
#   unit <- reactive({
#     input$unit
#     rangeInput()
#   })
#   
#   probes <- reactive({
#     input$probes
#     rangeInput()
#   })
  
  rangeInput <- reactive({
    df <- datasetInput()
    values$range  <- length(df[,1])
    if(input$unit == "Percentile") {
      values$first  <- ceiling((values$range/100) * input$percentile[1])
      values$last   <- ceiling((values$range/100) * input$percentile[2])
    } 
    else if(input$unit == "Absolute"){
        if(input$dataset == "Raw Data")
        {
          values$first  <- 1
          values$last   <- input$probes_raw
        } else {
          values$first  <- 1
          values$last   <- input$probes_normalisedI
        }   
    }
  })
  
  plotInput <- reactive({
    df     <- datasetInput()
    enable <- sepInput()
    rangeInput()
#     unit()
#     probes()
    p      <- plot_profile(df[values$first:values$last,],
                           treatments=treatment, 
                           sep=enable)
  })

  output$plot <- renderPlot({
    print(plotInput())
  })
  
  output$downloadData <- downloadHandler(
    filename = function() { paste(input$dataset, '_Data.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput(), file)
    }
  )

  output$downloadRangeData <- downloadHandler(
    filename = function() { paste(input$dataset, '_', values$first, '_', values$last, '_Range.csv', sep='') },
    content = function(file) {
      write.csv(datasetInput()[values$first:values$last,], file)
    }
  )
  
  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$dataset, '_ProfilePlot.png', sep='') },
    content = function(file) {
      png(file)
      print(plotInput())
      dev.off()
    }
  )
  
})

