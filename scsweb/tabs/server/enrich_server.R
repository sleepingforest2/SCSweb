init_enrich=function(cluster.markers,sp,enrich_way,enrich_type,enrich_p,plot_type){
     gene<-rownames(cluster.markers)
	 print("I'here")
	 if(sp=='human'){    
		gene.df<-bitr(gene, fromType = "SYMBOL", toType = "ENTREZID",OrgDb = org.Hs.eg.db)
		id<-na.omit(gene.df$ENTREZID)
		if(enrich_way=="GO"){
			result <- enrichGO(OrgDb="org.Hs.eg.db", gene = id, ont = enrich_type, pvalueCutoff = enrich_p, readable= TRUE)
		}else if(enrich_way=="KEGG"){
			result <- enrichKEGG(gene= id,organism  = 'hsa', pvalueCutoff = enrich_p)
		}
		print("enrich is done!")
		return(result)
	 }else if(sp=='mouse'){ 
		gene.df<-bitr(gene, fromType = "SYMBOL", toType = "ENTREZID",OrgDb = org.Mm.eg.db)
		id<-na.omit(gene.df$ENTREZID)
		print(paste(enrich_way,"I' in mouse"))
		if(enrich_way=="GO"){
		    print(paste(enrich_way,"I' in mouse GO"))
			result <- enrichGO(OrgDb="org.Mm.eg.db", gene = id, ont = enrich_type, pvalueCutoff = enrich_p, readable= TRUE)
		}else if(enrich_way=="KEGG"){
		    print(paste(enrich_way,"I' in mouse KEGG"))
			result <- enrichKEGG(gene= id,organism  = 'mmu', pvalueCutoff = enrich_p)
		}
		print("enrich is done!")
		return(result)
	 }
}

plot_enrich=function(result,enrich_way,plot_type){
     title_name=paste("Enrichment Top20",enrich_way,sep=" ")
     if(plot_type==1){
	     p=dotplot(result,showCategory=20,title=title_name) 
	 }else if(plot_type==0){
	     p=barplot(result,showCategory=20,title=title_name)
	 }
	 print(paste("plot is done!",plot_type))
	 return(p)
}