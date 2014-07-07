library(shiny)
library(shinyIncubator)
library(ggvis)

shinyServer(function(input, output, session) {
  values <- reactiveValues()
  
  gene_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$ID)) return(NULL)
    
    gene_x <- data_curr[data_curr$ID == x$ID, ]
    paste0("<b>", gene_x$Name, "</b><br>",
           "log Fold Change: ", gene_x$logFC, "<br>",
           "q Value: ", gene_x$adj.P.Val 
    )
  }
  
  datasetInput <- reactive({
    switch(input$dataset,
           "Co - Ly" = data_in[[1]],
           "Co - Hi" = data_in[[2]],
           "Co - Lo" = data_in[[3]],
           "Hi - Ly" = data_in[[4]],
           "Hi - Lo" = data_in[[5]],
           "Ly - Lo" = data_in[[6]],
           "Co - Sj" = data_in[[7]],
           "Ly - Sj" = data_in[[8]])
  })
  
  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$comparison, '_ProfilePlot.png', sep='') },
    content = function(file) {
      data <- datasetInput()
      png(file)
      print(gg_volcano(data))
      dev.off()
    }
  )
  
  output$unfiltered <- renderDataTable({
#     data <- topTable(data_in, coef = input$comparison, number = nrow(data_in$p.value), adjust.method="BH")
    data <- datasetInput()
    data <- data.table(data ,keep.rownames=TRUE)
    data
  })
  
  output$filtered <- renderDataTable({
#     data <- topTable(data_in, coef = input$comparison, p.value = input$pval, lfc = log2(input$fc),
#                      nrow(data_in$p.value), adjust.method = "BH")
    data <- datasetInput()
    data <- data.table(data ,keep.rownames=TRUE)
    fooB <<- data
    data
  })
  
  vis <- reactive({
    data <- datasetInput()
    foo <<- data
    data$threshold <- as.factor(abs(data$logFC) > log2(input$fc) &
                                  data$adj.P.Val < input$pval)
    data$ID <- rownames(data)
    data_curr <<- data
    data %>% ggvis(x = ~logFC, y = ~(-log10(adj.P.Val))) %>%
      layer_points(fill=~threshold, size := 50, size.hover := 200,
                   fillOpacity := 0.1, fillOpacity.hover := 0.5, 
                   stroke = ~threshold, key := ~ID) %>%
      add_tooltip(gene_tooltip, "hover")
#       vis %>% bind_shiny("plot1")
  })
  
  vis %>% bind_shiny("plot1")
  
})