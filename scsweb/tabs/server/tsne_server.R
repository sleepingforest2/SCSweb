init_dim=function(PBMC,reduction){
     print("reduction_init_dim")
     if(reduction=='tsne'){	     
	     PBMC=RunTSNE(object = PBMC, dims.use = 1:10)
	 }else if(reduction=='UMAP'){
	     PBMC<-RunUMAP(PBMC, dims =1:10)
		 print("RunUMAP")
	 }
	 return(PBMC)
}
init_dim_plot=function(PBMC,reduction){
     if(reduction=='tsne'){
	     p=DimPlot(PBMC, reduction = "tsne", label = TRUE, label.size=6,pt.size = 0.5)
	 }else if(reduction=='UMAP'){
	     p=DimPlot(PBMC, reduction ="umap",label = TRUE, label.size=6,pt.size = 0.5)
		 print("RunUMAP-DimPlot")
	 }
	 return(p)
}


