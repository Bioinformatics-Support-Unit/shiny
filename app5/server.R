library(shiny)
library(shinyIncubator)
library(ggvis)

shinyServer(function(input, output, session) {
  values <- reactiveValues()
  
  gene_tooltip <- function(x) {
    if (is.null(x)) return(NULL)
    if (is.null(x$ID)) return(NULL)
    
    gene_x <- data_curr[data_curr$ID == x$ID, ]
    paste0("<b>", gene_x$symbol, "</b><br>",
           "log Fold Change: ", gene_x$logFC, "<br>",
           "q Value: ", gene_x$adj.P.Val 
    )
  }
  
  datasetInput <- reactive({
    switch(input$dataset,
           "mic - threep" = "mic - threep",
           "HPC - HP140"  = "HPC - HP140")
  })
  
  output$downloadPlot <- downloadHandler(
    filename = function() { paste(input$comparison, '_ProfilePlot.png', sep='') },
    content = function(file) {
      cont_in <- datasetInput()
      data    <- topTable(fit2, coef=cont_in, number=nrow(anno_df), adjust.method=input$mtc)
      png(file)
      print(gg_volcano(data, input$fc, input$pval))
      dev.off()
    }
  )
  
  output$unfiltered <- renderDataTable({
    cont_in <- datasetInput()
    data <- topTable(fit2, coef=cont_in, number=nrow(anno_df), adjust.method=input$mtc)
    data <- data[,-c(1,2,3,7,10,13)]
    data <- data.table(data ,keep.rownames=TRUE)
    data
  })
  
  output$filtered <- renderDataTable({
    cont_in <- datasetInput()
    data <- topTable(fit2, coef=cont_in, number=nrow(anno_df), adjust.method=input$mtc)
    data$threshold <- as.factor(data$adj.P.Val < input$pval & abs(data$logFC) > log2(input$fc))
    data <- data[data$threshold == TRUE,]
    data <- data[,-c(1,2,3,7,10,13)]
    data <- data.table(data ,keep.rownames=TRUE)
    data
  })

  output$mirna_targets <- renderDataTable({
    cont_in <- datasetInput()
    data <- topTable(fit2, coef=cont_in, number=nrow(anno_df), adjust.method=input$mtc,
                     p.value=input$pval, lfc=log2(input$fc))
    
    entrez_map_1 <- na.omit(nuID2EntrezID(data$ID, lib.mapping='lumiHumanIDMapping', 
                                          filterTh = c(Strength1 = 95, Uniqueness = 95)))
    entrez_map_1 <- entrez_map_1[entrez_map_1 != ""]
    entrez_map_1 <- entrez_map_1[as.vector(unlist(lapply(entrez_map_1, 
                                                         function(x) exists(x, targetscan.Hs.egTARGETS)))) == T]
    gene_targets_1 <- as.vector(unlist(mget(entrez_map_1, targetscan.Hs.egTARGETS)))
    data <- data.table(gene_targets_1 ,keep.rownames=TRUE)
    data
  })
  
  output$mirna_targets_int <- renderDataTable({
    cont_in <- datasetInput()
    data1 <- topTable(fit2, coef=1, number=nrow(anno_df), adjust.method=input$mtc,
                     p.value=input$pval, lfc=log2(input$fc))
    
    entrez_map_1 <- na.omit(nuID2EntrezID(data1$ID, lib.mapping='lumiHumanIDMapping', 
                                          filterTh = c(Strength1 = 95, Uniqueness = 95)))
    entrez_map_1 <- entrez_map_1[entrez_map_1 != ""]
    entrez_map_1 <- entrez_map_1[as.vector(unlist(lapply(entrez_map_1, 
                                                         function(x) exists(x, targetscan.Hs.egTARGETS)))) == T]
    gene_targets_1 <- as.vector(unlist(mget(entrez_map_1, targetscan.Hs.egTARGETS)))
    
    data2 <- topTable(fit2, coef=2, number=nrow(anno_df), adjust.method=input$mtc,
                      p.value=input$pval, lfc=log2(input$fc))
    entrez_map_2 <- na.omit(nuID2EntrezID(data2$ID, lib.mapping='lumiHumanIDMapping', 
                                          filterTh = c(Strength1 = 95, Uniqueness = 95)))
    entrez_map_2 <- entrez_map_2[entrez_map_2 != ""]
    entrez_map_2 <- entrez_map_2[as.vector(unlist(lapply(entrez_map_2, 
                                                         function(x) exists(x, targetscan.Hs.egTARGETS)))) == T]
    gene_targets_2 <- as.vector(unlist(mget(entrez_map_2, targetscan.Hs.egTARGETS)))
    
    data <- intersect(gene_targets_1, gene_targets_2)
    data <- data.table(data ,keep.rownames=TRUE)
    data
  })
  
  vis <- reactive({
    cont_in <- datasetInput()
#     data <- data[,-c(1,2,3,7,10,13)]
    data    <- topTable(fit2, coef=cont_in, number=nrow(anno_df), adjust.method=input$mtc)
    data$threshold <- as.factor(abs(data$logFC) > log2(input$fc) &
                              data$adj.P.Val < input$pval)
    data$ID <- rownames(data)
    data_curr <<- data
    data %>% ggvis(x = ~logFC, y = ~(-log10(adj.P.Val))) %>%
      layer_points(fill=~threshold, size := 50, size.hover := 200,
                   fillOpacity := 0.1, fillOpacity.hover := 0.5, 
                   stroke = ~threshold, key := ~ID) %>%
      add_tooltip(gene_tooltip, "hover")
  })
  
  vis %>% bind_shiny("plot1")
  
})