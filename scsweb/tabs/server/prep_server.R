init_createPBMC=function(dataPBMC,sp){
     PBMC <- CreateSeuratObject(dataPBMC, min.cells = 1, min.features = 0, project = '10x_PBMC')
     if(sp == 'human'){
	     PBMC[["percent.mt"]] <- PercentageFeatureSet(object = PBMC, pattern = "^MT-")       
	 }
	 if(sp == 'mouse'){
		 PBMC[["percent.mt"]] <- PercentageFeatureSet(object = PBMC, pattern = "^mt-")
	 }
	 return(PBMC)
}

init_prep_summary=function(PBMC1){
     summary_colname<-c("nFeature_RNA", "nCount_RNA", "percent.mt")
	 nfr<-as.matrix(summary(PBMC1[["nFeature_RNA"]]))
	 summary_rowname<-apply(nfr,1,function(x) substring(x,0,7))
	 nfr<-apply(nfr,1,function(x) substring(x,9))
	 ncr<-as.matrix(summary(PBMC1[["nCount_RNA"]]))
	 ncr<-apply(ncr,1,function(x) substring(x,9)) 
	 mt<-as.matrix(summary(PBMC1[["percent.mt"]]))
	 mt<-apply(mt,1,function(x) substring(x,9)) 
	 sum_frame<-as.data.frame(cbind(summary_rowname,nfr,ncr,mt))
	 colnames(sum_frame)<-c("",summary_colname)
	 return(sum_frame)
}

init_prep=function(PBMC){
     `%notin%` <- Negate(`%in%`)
     PBMC <- subset(PBMC, subset = nFeature_RNA %notin% boxplot.stats(PBMC$nFeature_RNA)$out & 
                     nCount_RNA %notin% boxplot.stats(PBMC$nCount_RNA)$out & 
                     percent.mt %notin% boxplot.stats(PBMC$percent.mt)$out)
     return(PBMC)
}