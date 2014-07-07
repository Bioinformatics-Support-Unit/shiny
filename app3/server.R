shinyServer(function(input, output, session) {
  
  values <- reactiveValues()
  
  datasetInput <- reactive({
    foo <<- input$foo
    withProgress(session, {
      setProgress(message = "Normalising, please wait",
                  detail = "This will take a few minutes...")
                  values$df <- pca_normalise(values$df, input$foo, treatment_in[[1]], session)
    })
  })

  plotInput <- reactive({
    datasetInput()
    affycoretools::plotPCA(values$df[[1]], groups=as.numeric(as.factor(values$df[[2]])), 
            groupnames=levels(as.factor(values$df[[2]])),
            addtext=(input$foo), pcs=c(1,2), plot3d=FALSE, main="")
  })

  output$checkbGroups <- renderUI({
    checkboxGroupInput(inputId = 'foo', label = '', 
                       choices = check_in, 
                       selected = check_in)
    #     lapply(1:length(data_in), function(x){
    #       do.call(checkboxGroupInput, list(inputId = x, label = x, choices = colnames(data_in[[x]])))
    #     })
  })

  output$plot <- renderPlot({
    plotInput()
  })

  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$dataset, '_PCA.png', sep='') },
    content = function(file) {
      png(file)
      plotInput()
      dev.off()
    }
  )
  
})