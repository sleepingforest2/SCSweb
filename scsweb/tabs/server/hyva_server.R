init_hyva=function(PBMC,rawData){
     PBMC <- NormalizeData(object = PBMC, normalization.method = "LogNormalize", scale.factor = 10000)
	 PBMC <- AddMetaData(object = PBMC,metadata = apply(rawData, 2, sum),col.name = 'nUMI_raw')
	 PBMC <- ScaleData(object = PBMC, vars.to.regress = c('nUMI_raw'), model.use = 'linear', use.umi = FALSE)
     PBMC <- FindVariableFeatures(object = PBMC, mean.function = ExpMean, dispersion.function = LogVMR, mean.cutoff = c(0.0125,3), dispersion.cutoff = c(0.5,Inf)) 
	 return(PBMC)
}