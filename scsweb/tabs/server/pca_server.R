init_pca=function(PBMC){
     all.genes <- rownames(PBMC)
     PBMC <- ScaleData(PBMC, features = all.genes)
     PBMC <- RunPCA(object = PBMC, pc.genes = PBMC@var.genes)
	 return(PBMC)
}