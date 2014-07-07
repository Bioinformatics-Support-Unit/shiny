library(shiny)
library(shinyIncubator)
source("profile_plot.R")

shinyServer(function(input, output, session) {
  
  values <- reactiveValues()
  
  datasetInput <- reactive({
    for(i in 1:length(data_in)) {
      if(input$dataset == data_names[i]) {
        values$df        <- data_in[[i]]
        values$treatment <- treatment_in[[i]]
      }
    }
  })
  
  sepInput <- reactive({
    switch(input$sep,
           "Yes" = TRUE,
           "No" = FALSE)
  })
  
  rangeInput <- reactive({
    datasetInput()
    values$range  <- length(values$df[,1])
    values$first  <- ceiling((values$range/100) * input$percentile[1])
    values$last   <- ceiling((values$range/100) * input$percentile[2])
    values$range_select <- values$last - values$first + 1
  })
  
  plotInput <- reactive({
    datasetInput()
    enable <- sepInput()
    rangeInput()
    p      <- plot_profile(values$df[values$first:values$last,],
                           treatments=values$treatment, 
                           sep=enable)
  })

  output$plot <- renderPlot({
    withProgress(session, {
      setProgress(message = "Calculating",
                  detail = "Working...")
      print(plotInput())
    })
  })

  output$n_probes <- renderText({ 
    values$range_select
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

