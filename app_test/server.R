shinyServer(function(input, output) {
  values <- reactiveValues()
  
  datasetInput <- reactive({
    values$data <- input$foo
  })

  plotInput <- reactive({
    datasetInput()
    plot(x=values$data, y=values$data, col=values$data)
  })

  output$checkbGroups <- renderUI({
    checkboxGroupInput(inputId = 'foo', label = 'Numbers To use', 
                       choices = data_in, 
                       selected = data_in)
    
  })

  output$plot <- renderPlot({
    plotInput()
  })
})