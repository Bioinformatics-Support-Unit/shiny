
targets_master        <- readTargets(path = "./" )
check_in <- targets_master$Cy3

pca_normalise <- function(raw_data, targets_in, treatments_in, session) {
  withProgress(session, min = 0, max = 10, {
    setProgress(message = "Normalisation Procedure...")
    foo <- targets_in
    targets       <- c()
    treatment_out <- c()
    for(i in 1:length(targets_in)){
      targets <- rbind(targets, targets_master[grep(targets_in[i], targets_master$Cy3),])        
      treatment_out <- c(treatment_out, treatments_in[grep(targets_in[i], targets_master$Cy3)])
    }
    
    setProgress(value = 2)
    setProgress(detail = "Reading Raw Data...")
    
    RGList         <- read.maimages(targets[,c("Cy3", "Cy5")], source = "imagene", path = "./" )
    
    setProgress(value = 3)
    setProgress(detail = "Reading Annotation...")
    
    RGList$genes   <- readGAL(path = "./")
    RGList$printer <- getLayout(RGList$genes)
    obatch <- createAB(RGList)
    
    setProgress(value = 5)
    setProgress(detail = "Subsetting Spike Probes...")
    
    spikein.all <- grep('^spike', featureNames(obatch), value=TRUE)
    spikein.subset <- setdiff(spikein.all, 'spike_control_f')
    
    setProgress(value = 6)
    setProgress(detail = "Applying Normalisation Calculations...")
    
    eset.spike <- NormiR(obatch, bg.correct=FALSE,
                         normalize.method='spikein',
                         normalize.param=list(probeset.list=spikein.subset, figures.show=FALSE), #, figures.output="file"),
                         summary.method='medianpolish')
    
    setProgress(value = 9)
    setProgress(detail = "Creating Output...")
    Sys.sleep(0.4)
    
    output <- list()
    output[[1]] <- as.matrix(eset.spike[,1:length(treatment_out)])
    output[[2]] <- treatment_out
    
    setProgress(value = 10)
    setProgress(detail = "Complete. Rendering...")
    Sys.sleep(0.4)
    return(output)
  })
}