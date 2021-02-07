init_differ=function(PBMC,ident){
     cluster.markers <- FindMarkers(object = PBMC, ident.1 = ident, min.pct = 0.25)
	 markers<-rownames(cluster.markers)
	 marker_gene<- markers[1:20]
	 return(marker_gene)
}
init_differ_new=function(marker_gene){
     rank<-c(1:20)
	 new=cbind(rank[1:10],marker_gene[1:10],rank[11:20],marker_gene[11:20])
	 colnames(new)<-c("rank","gene name","rank","gene name")
	 return(new)
}