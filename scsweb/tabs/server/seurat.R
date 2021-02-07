init<-function(mailname,workname,filename,sp){
if(!dir.exists("./mail")){
     dir.create("./mail")
}
setwd("./mail")
dir.create(mailname)
setwd(mailname)
dir.create(workname)
setwd(workname)
######################################
#第一步：归一化处理 
######################################
raw_dataPBMC <- read.csv(filename,header = TRUE,row.names = 1)
dataPBMC <- log2(1 + sweep(raw_dataPBMC, 2, median(colSums(raw_dataPBMC))/colSums(raw_dataPBMC), '*'))
#对表达矩阵进行QC，画出直方图
Gene_distrubtion<-apply(dataPBMC,1,function(x) sum(x>0))
Barcode_distrubtion<-apply(dataPBMC,2,function(x) sum(x>0))	
#pdf("./result.pdf")
png("./Gene_distrubtion.png")
hist(Gene_distrubtion,col="#9DC3E6",main="Gene_distrubtion")
dev.off()
png("./Barcode_distrubtion.png")
hist(Barcode_distrubtion,col="#9DC3E6",main="Barcode_distrubtion")
dev.off()
######################################
#第二步：数据预处理 
######################################
PBMC <- CreateSeuratObject(dataPBMC, min.cells = 1, min.features = 0, project = '10x_PBMC')
if(sp=='human'){
     PBMC[["percent.mt"]] <- PercentageFeatureSet(object = PBMC, pattern = "^MT-")
}else if(sp=='mouse'){
PBMC[["percent.mt"]] <- PercentageFeatureSet(object = PBMC, pattern = "^mt-")
}
VlnPlot(object = PBMC, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
ggsave("pre-vn.png")
`%notin%` <- Negate(`%in%`)
PBMC <- subset(PBMC, subset = nFeature_RNA %notin% boxplot.stats(PBMC$nFeature_RNA)$out & 
                             nCount_RNA %notin% boxplot.stats(PBMC$nCount_RNA)$out & 
                             percent.mt %notin% boxplot.stats(PBMC$percent.mt)$out)
VlnPlot(object = PBMC, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
ggsave("after-vn.png")
PBMC <- NormalizeData(object = PBMC, normalization.method = "LogNormalize", scale.factor = 10000)
PBMC <- AddMetaData(object = PBMC,metadata = apply(raw_dataPBMC, 2, sum),col.name = 'nUMI_raw')
PBMC<- ScaleData(object = PBMC, vars.to.regress = c('nUMI_raw'), model.use = 'linear', use.umi = FALSE)

######################################
#第三步：找高度变异基因
######################################
PBMC<- FindVariableFeatures(object = PBMC, mean.function = ExpMean, dispersion.function = LogVMR, mean.cutoff = c(0.0125,3), dispersion.cutoff = c(0.5,Inf)) 
top10 <- head(x = VariableFeatures(object = PBMC), 10)
plot1 <- VariableFeaturePlot(object = PBMC)
plot2 <- LabelPoints(plot = plot1, points = top10, repel = TRUE)
plot2
ggsave("hyva.png")
######################################
#第四步：PCA降维  
######################################
PBMC <- RunPCA(object = PBMC, pc.genes = PBMC@var.genes)
DimPlot(PBMC, reduction ="pca")
ggsave("pca1.png")
ElbowPlot(PBMC)
ggsave("pca2.png")
VizDimLoadings(PBMC, dims =1:4, reduction ="pca")
ggsave("pca3.png")
png("./pca4.png")
DimHeatmap(PBMC, dims =1:6, cells =500, balanced =TRUE)
dev.off()
######################################
#第五步：细胞分群 tab：1、饼图
######################################
PBMC <- FindNeighbors(PBMC, reduction = "pca", dims = 1:10,k.param = 35)  
PBMC<- FindClusters(object = PBMC, resolution = 0.9, verbose=F)    
tmp=table(Idents(object=PBMC))
newpalette<-colorRampPalette(brewer.pal(9,"Pastel1"))(length(tmp))
names(tmp)<-paste(paste("cls",names(tmp),sep=""),tmp[1:length(tmp)],sep=":")
tmp<-as.data.frame(tmp)
p = ggplot(tmp, aes(x = "", y = tmp$Freq, fill = tmp$Var1)) + 
  geom_bar(stat = "identity", width = 1) +    
  coord_polar(theta = "y") + 
  labs(x = "", y = "", title = "") + 
  theme(axis.ticks = element_blank()) + 
  theme(legend.title = element_blank(), legend.position = "top")+   
  scale_fill_manual(values=newpalette)
p
ggsave("pie.png")
######################################
#第六步：tSNE降维 
######################################
PBMC <- RunTSNE(object = PBMC, dims.use = 1:10)
DimPlot(PBMC, reduction = "tsne", label = TRUE, label.size=6,pt.size = 0.5)
ggsave("tsne.png")
PBMC<-RunUMAP(PBMC, dims =1:10)
DimPlot(PBMC, reduction ="umap",label = TRUE, label.size=6,pt.size = 0.5)
ggsave("umap.png")
######################################
#第七步：找差异基因 tab：1、指定簇的marker基因图 2、top20基因表格 3、可视化两个基因 
######################################
cluster.markers <- FindMarkers(object = PBMC, ident.1 = 0, min.pct = 0.25)
markers<-rownames(cluster.markers)
marker_gene<- markers[1:20]
rank<-c(1:20)
new=cbind(rank[1:10],marker_gene[1:10],rank[11:20],marker_gene[11:20])
colnames(new)<-c("rank","gene name","rank","gene name")
VlnPlot(PBMC, features = marker_gene[1])    
ggsave("clu-vn.png")
FeaturePlot(object = PBMC,features =marker_gene[1:2], cols = c("grey", "blue"))
ggsave("clu-fea.png")
######################################
#第八步：富集分析 tab：1、泡泡图 2、柱状图
######################################
marker_gene<-rownames(cluster.markers)
if(sp=='human'){
    GO_db="org.Hs.eg.db"
	kegg_db="hsa"
}else if(sp=='mouse'){
    GO_db="org.Mm.eg.db"
	kegg_db="mmu"
}
eg = bitr(marker_gene, fromType="SYMBOL", toType="ENTREZID", OrgDb=GO_db)
id=na.omit(eg$ENTREZID)
display_number = c(10, 10, 10)
ego_MF <- enrichGO(OrgDb=GO_db, gene = id, ont = "MF", pvalueCutoff = 0.5, readable= TRUE)
ego_result_MF <- as.data.frame(ego_MF)[1:display_number[1], ]
ego_result_MF <- ego_result_MF[order(-ego_result_MF$Count),]
ego_CC <- enrichGO(OrgDb=GO_db, gene = id, ont = "CC", pvalueCutoff = 0.5, readable= TRUE)
ego_result_CC <- as.data.frame(ego_CC)[1:display_number[2], ]
ego_result_CC <- ego_result_CC[order(-ego_result_CC$Count),]
ego_BP <- enrichGO(OrgDb=GO_db, gene = id, ont = "BP", pvalueCutoff = 0.5, readable= TRUE)
ego_result_BP <- na.omit(as.data.frame(ego_BP)[1:display_number[3], ])
ego_result_BP <- ego_result_BP[order(-ego_result_BP$Count),]
go_enrich_df <- data.frame(ID=c(ego_result_BP$ID, ego_result_CC$ID, ego_result_MF$ID),
                           Description=c(ego_result_BP$Description, ego_result_CC$Description, ego_result_MF$Description),
                           GeneNumber=c(ego_result_BP$Count, ego_result_CC$Count, ego_result_MF$Count),
                           type=factor(c(rep("biological process", display_number[1]), rep("cellular component", display_number[2]),
                           rep("molecular function", display_number[3])), 
						   levels=c("biological process", "cellular component", "molecular function")))
go_enrich_df$number <- factor(rev(1:nrow(go_enrich_df)))
write.table(go_enrich_df,file = "./GO.txt")
label_tmp<-as.character(go_enrich_df$Description[1:30])
label<-NA
for(i in 1:length(label_tmp)){
   tmp<-label_tmp[i]
   label<-c(tmp,label)
}
label<-label[1:30]
CPCOLS <- c("#8DA1CB", "#FD8D62", "#66C3A5")
ggplot(data=go_enrich_df, aes(x=number, y=GeneNumber, fill=type)) +
  geom_bar(stat="identity", width=0.8) + coord_flip() + 
  scale_fill_manual(values = CPCOLS) + theme_bw() + 
  scale_x_discrete(labels=label) + 
  xlab("GO term") + 
  labs(title = "The Most Enriched GO Terms")
ggsave("go.png")
ekk <- enrichKEGG(gene = id,organism  = kegg_db,pvalueCutoff  = 0.2,pAdjustMethod  = "BH",qvalueCutoff  = 0.2)
write.table(ekk,file = "./kegg.txt")
dotplot(ekk,font.size=8,showCategory=10,title="The Most Enriched KEGG Terms")
ggsave("kegg.png")
mysendmail =function(wd,to,subject,msg,files=array()){
   if(is.na(files)[1]){
      attach.files <- NULL
   }else{
      attach.files <-paste(wd,files,sep='/')
   }
   from = "948171274@qq.com"   
   #这里输入发送者的邮箱
   send.mail(from = from,
             to = to,
             subject = subject,
             body = msg,
             smtp = list(host.name = "smtp.qq.com",port =587,user.name=from,passwd = "tduppxvbknjobbhc", tsl =TRUE),
             authenticate = TRUE,
             send = TRUE,
             attach.files = attach.files,
             encoding = "utf-8")
}
result <- list.files()
retant <- mailname
message <- c("your result")
mysendmail(wd = "./", subject = "SCS-result", msg = message, to = retant,files = result)
}