init_clust=function(PBMC,dim1_pca,dim2_pca){
    PBMC <- FindNeighbors(PBMC, reduction = "pca", dims = dim1_pca:dim2_pca,k.param = 35)
    PBMC <- FindClusters(object = PBMC, resolution = 0.9, verbose=F)
	return(PBMC)
}
init_clust_plot=function(PBMC){
    tmp=table(Idents(object=PBMC))
	newpalette<-colorRampPalette(brewer.pal(9,"Pastel1"))(length(tmp))
	clustnames<-paste("cluster",names(tmp),sep="")
    names(tmp)<-paste(paste("cls",names(tmp),sep=""),tmp[1:length(tmp)],sep=":")
	tmp<-as.data.frame(tmp)
	p = ggplot(tmp, aes(x = "", y = tmp$Freq, fill = tmp$Var1)) + 
        geom_bar(stat = "identity", width = 1) +    
		coord_polar(theta = "y") + 
		labs(x = "", y = "", title = "") + 
		theme(axis.ticks = element_blank()) + 
		theme(legend.title = element_blank(), legend.position = "top")+   
		scale_fill_manual(values=newpalette)
	return(p)
}