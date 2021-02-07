init_norm=function(rawData){
     dataPBMC=log2(1 + sweep(rawData, 2, median(colSums(rawData))/colSums(rawData), '*'))
	 return(dataPBMC)
}
hist_gene=function(dataPBMC){
     gene_distrubtion=apply(dataPBMC,1,function(x) sum(x>0))
	 tmp<-as.data.frame(gene_distrubtion)
	 p<-ggplot(tmp, aes(x=gene_distrubtion)) +
         geom_histogram(binwidth=50, colour="black", fill="#9DC3E6") +
		 geom_vline(aes(xintercept=mean(gene_distrubtion, na.rm=T)),  
               color="red", linetype="dashed", size=1) +
         labs(title="The hist of Gene_distrubtion")+ 
	     theme_bw()+
	     theme(panel.border = element_blank(), 
	           panel.grid.major = element_blank(),
	           panel.grid.minor = element_blank(), 
		       axis.line = element_line(colour = "black"),
		       plot.title = element_text(hjust = 0.5))	   
	 return(p)
}
hist_barcode=function(dataPBMC){
     barcode_distrubtion=apply(dataPBMC,2,function(x) sum(x>0))
	 tmp<-as.data.frame(barcode_distrubtion)
	 p<-ggplot(tmp, aes(x=barcode_distrubtion)) +
         geom_histogram(binwidth=100, colour="black", fill="#9DC3E6") +
		 geom_vline(aes(xintercept=mean(barcode_distrubtion, na.rm=T)),  
               color="red", linetype="dashed", size=1) +
         labs(title="The hist of Barcode_distrubtion")+ 
	     theme_bw()+
	     theme(panel.border = element_blank(), 
	           panel.grid.major = element_blank(),
	           panel.grid.minor = element_blank(), 
		       axis.line = element_line(colour = "black"),
		       plot.title = element_text(hjust = 0.5))	   
	 return(p)
}
