library(shiny)
for( i in 1:length(list.files("./tabs/server/"))){
  source(paste("./tabs/server/",list.files("./tabs/server/")[i],sep=""))
}
#限制上传15MB
options(shiny.maxRequestSize = 500*1024^2)
shinyServer(function(input, output,session) {
      #-- biblio js ----
  tags$link(rel="stylesheet", type = "text/css",
                href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css")
  tags$link(rel="stylesheet", type = "text/css",
                href = "https://fonts.googleapis.com/css?family=Open+Sans|Source+Sans+Pro")
  
output$panel <- renderUI({
    source('tabs/ui/upload.R',local=T)$value})

#读入数据
  data.pool <- reactiveValues(raw=NA,Gene_distrubtion=NA,raw2=NA)
  observeEvent(input$email_sub,{
    if(isTruthy(!is.null(input$raw2) & !is.null(input$email) & !is.null(input$sp2))){
        if(isTruthy(is.null(input$fname))){
            init(input$email,"defalut",input$raw2$datapath,input$sp2)
        }else{
            init(input$email,input$fname,input$raw2$datapath,input$sp2)
        }
    }}
  )
observe({
         if(isTruthy(!is.null(input$raw))){
         data.pool$rawData <- read.csv(input$raw$datapath,header=T,row.names=1)
       data.pool$sp<-input$sp
         }
     })
   
    #直方图
     observeEvent(input$norm, {
         output$panel <- renderUI({
             source('tabs/ui/norm.R',local=T)$value
       })
     data.pool$dataPBMC<-init_norm(data.pool$rawData)
     data.pool$Gene_distrubtion_p <- hist_gene(data.pool$dataPBMC)
     data.pool$Barcode_distrubtion_p <- hist_barcode(data.pool$dataPBMC)
       output$histplot1<-renderPlotly(
         ggplotly(data.pool$Gene_distrubtion_p)
         )
     output$hist1<-renderPrint(
           print("The X-axis is the level of expression of each gene in the cell,The Y-axis is the number of genes currently expressed;")
       ) 
       output$histplot2<-renderPlotly(
       ggplotly(data.pool$Barcode_distrubtion_p)
         )
       output$hist2<-renderPrint(
           print("The X-axis is the number of genes expressed in each cell,The Y-axis is the number of cells currently;")
       ) 
     output$downloadhist1 <- downloadHandler(
             filename=paste("SCS-",".png",sep=""),
             content = function(file) {
                 data.pool$Gene_distrubtion_p
                 ggsave(file,width=8,height=10)
             }
     ) 
         output$downloadhist2 <- downloadHandler(
             filename = paste("SCS-",".png",sep=""),
             content = function(file) {
                 data.pool$Barcode_distrubtion_p
                 ggsave(file,width=8,height=10)
             }
     )     

     })
   
     #小提琴图 pre-process
     observeEvent(input$prep, {
         output$panel <- renderUI({
         source('tabs/ui/prep.R',local=T)$value
     })
     data.pool$PBMC <- init_createPBMC(data.pool$dataPBMC,data.pool$sp)
     data.pool$PBMC1<-data.pool$PBMC
     #data.pool$p<-VlnPlot(object =data.pool$PBMC1, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
     data.pool$sum_frame<-init_prep_summary(data.pool$PBMC1)
     data.pool$PBMC<-init_prep(data.pool$PBMC)
     output$prepplot1<-renderPlot(
       VlnPlot(object =data.pool$PBMC1, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
     )
     output$pre1<-renderPrint(
       print("This is a violin diagram, where the dots represent each cell. The distribution of the number of genes identified in each cell is shown on the left. The distribution of the number of UMI after weight removal is shown in the middle. The distribution of cells containing mitochondria is shown on the right.")
     )
     output$downloadprep1 <- downloadHandler(
       filename = paste("SCS-",".png",sep=""),
       content = function(file) {
         p<-VlnPlot(object =data.pool$PBMC1, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
         ggsave(file,plot=p,width=8,height=10)
        }
     )
     output$sum1 <- renderTable(
       data.pool$sum_frame
     )
     output$sum2 <- renderPrint(
       print("Show the minimum value, maximum value, quartile, mean and median of the violin graph before pre-process.")
     )
     output$downloadsum1 <- downloadHandler(
       filename = paste("SCS-",".csv",sep=""),
       content = function(file) {
           write.csv(data.pool$sum_frame,file)
         }
     )
     output$prepplot2<-renderPlot(
       VlnPlot(object =data.pool$PBMC, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
     )
     output$pre2<-renderPrint(
       print("This is a violin diagram after pre-process.")
     )
     output$downloadprep2 <- downloadHandler(
       filename = paste("SCS-",".png",sep=""),
       content = function(file) {
         VlnPlot(object =data.pool$PBMC, features = c("nFeature_RNA", "nCount_RNA", "percent.mt"), ncol = 3)
         ggsave(file,width=8,height=10)
       }
         )  
     })

     #top10 plot hyva
     observeEvent(input$hyva, {
     output$panel <- renderUI({
       source('tabs/ui/hyva.R',local=T)$value
     })
     data.pool$PBMC1=NA
     data.pool$PBMC <- init_hyva(data.pool$PBMC,data.pool$rawData)  
     data.pool$top10 <- head(x = VariableFeatures(object = data.pool$PBMC), 10)
     data.pool$plot1 <- VariableFeaturePlot(object = data.pool$PBMC)
     data.pool$plot2 <- LabelPoints(plot = data.pool$plot1, points =data.pool$top10, repel = TRUE)
     output$hyvaplot<-renderPlot(
       data.pool$plot2
     )
     output$downloadhyva <- downloadHandler( 
       filename = paste("SCS-",".png",sep=""),
       content = function(file) {
         ggsave(file,plot=data.pool$plot2,width=8,height=10)
     }) 
     output$hyva <- renderPrint(
       print("To identify a subset of the characteristics of high intercellular heterogeneity in the dataset，each point represents a gene, and the first 2,000 genes are displayed by default, which is shown in red. The X-axis represents the average expression of a gene in all cells, and the Y-axis represents the corresponding standard deviation.")
     )
   })

     #PCA
     observeEvent(input$pca, {
     output$panel <- renderUI({
       source('tabs/ui/pca.R',local=T)$value
       })
         data.pool$PBMC <- init_pca(data.pool$PBMC)

     output$PCA1<-renderPlotly(
       ggplotly(DimPlot(data.pool$PBMC, reduction ="pca"))
     )
     output$pca1<-renderPrint(
       print("Graphs the output of a dimensional reduction technique on a 2D scatter plot where each point is a cell. The first two principal components are used for dimensionality reduction classification.")
     )
     output$PCA2<-renderPlotly(
             ggplotly(ElbowPlot(data.pool$PBMC))
     )
     output$pca2<-renderPrint(
       print("A heuristic approach. The X-axis is the principal component, and the Y-axis is the percentage of the interpretation of the corresponding principal component, based on the function.")
     )
     data.pool$pviz<-VizDimLoadings(data.pool$PBMC, dims =1:4, reduction ="pca")
     output$PCA3<-renderPlot(
       data.pool$pviz
     )
     output$pca3<-renderPrint(
       print("The figure shows that the current principal component is a linear combination of the genes in the figure. The larger the absolute value is, the stronger the correlation is. Positive value means positive correlation, conversely, negative value means negative correlation.")
     )
     output$PCA4<-renderPlot(
       DimHeatmap(data.pool$PBMC, dims =1:6, cells =500, balanced =TRUE)
     )
     output$pca4<-renderPrint(
       print("PC was explored to determine the relevant sources of heterogeneity. The better the differentiation effect, the more information the principal component contained. The corresponding genes are also useful for further downstream analysis. ")
     )
     output$downloadviz <- downloadHandler(
       filename = paste("SCS-",".png",sep=""),
       content = function(file) {
        ggsave(file,plot=data.pool$pviz,width=8,height=10)
      }
     ) 
     output$downloadheat <- downloadHandler(
       filename = paste("SCS-",".png",sep=""),
       content = function(file) {
        png(file)
        DimHeatmap(data.pool$PBMC, dims =1:6, cells =500, balanced =TRUE)
        dev.off()
      }
     ) 
     output$downloadDim <- downloadHandler(
      filename = paste("SCS-",".png",sep=""),
      content = function(file) {
        DimPlot(data.pool$PBMC, reduction ="pca")
        ggsave(file,width=8,height=10)
      }
    ) 
    output$downloadelbow <- downloadHandler(
      filename = paste("SCS-",".png",sep=""),
      content = function(file) {
        ElbowPlot(data.pool$PBMC)
        ggsave(file,width=8,height=10)
      }
    ) 
    data.pool$dim1_pca<-1
    data.pool$dim2_pca<-10
    observeEvent(input$refresh, {
      sliderValues <- reactive({
        data.frame(
        Name = c("VizDimLoadings:","DimHeatmap:","select PCA for cell clust:"),
        Value = c(input$dim1,input$dim2,input$dimpca), 
        stringsAsFactors=FALSE
        )
      })
      data.pool$dim1_pca<-sliderValues()$Value[5]
      data.pool$dim2_pca<-sliderValues()$Value[6]
      data.pool$pviz<-VizDimLoadings(data.pool$PBMC, dims =sliderValues()$Value[1]:sliderValues()$Value[2], reduction ="pca")
      output$PCA3<-renderPlot(
        data.pool$pviz
      )
      output$PCA4<-renderPlot(
        DimHeatmap(data.pool$PBMC, dims =sliderValues()$Value[3]:sliderValues()$Value[4], cells =500, balanced =TRUE)
      )
      output$downloadheat <- downloadHandler(
       filename = paste("SCS-",".png",sep=""),
       content = function(file) {
        png(file)
        DimHeatmap(data.pool$PBMC, dims =sliderValues()$Value[3]:sliderValues()$Value[4], cells =500, balanced =TRUE)
        dev.off()
      })
    })
  })

    #细胞分群
    observeEvent(input$clust, {
    output$panel <- renderUI({
      source('tabs/ui/clust.R',local=T)$value
    })
    data.pool$PBMC <- init_clust(data.pool$PBMC,data.pool$dim1_pca,data.pool$dim2_pca)
    data.pool$p = init_clust_plot(data.pool$PBMC)
    output$panplotResult<-renderPlot(      
      data.pool$p
    )
    output$clust <- renderPrint(
      print("First, the data dimension selected by the user was taken as input, and the KNN diagram was constructed according to the Euclidean distance in PCA space, also the weight between cells was updated according to the similarity within the region. Then clustering is carried out according to the resolution parameters set by the user. Different colors represent different categories, where the scale represents the X-axis in the bar chart. ")
    )
    output$downloadpan <- downloadHandler(
      filename = paste("SCS-",".png",sep=""),
      content = function(file) {
        ggsave(file,plot=data.pool$p,width=8,height=10)
      }
    ) 
  })
  
    #tSNE降维
    observeEvent(input$tsne, {    
    output$panel <- renderUI({
      source('tabs/ui/tsne.R',local=T)$value
    })
    observeEvent(input$ref_tsne,{
    print(paste("reduction-",input$reduction)) 
    data.pool$PBMC <- init_dim(data.pool$PBMC,input$reduction)
    data.pool$dim_p <- init_dim_plot(data.pool$PBMC,input$reduction)
    
    output$tplot<-renderPlotly(
      ggplotly(data.pool$dim_p)
    )
    output$tsne <- renderPrint(
      print("A nonlinear dimension reduction method.Each color represents a cell group identified after the cluster, the scatter represents each cell, and the number in the figure represents the cluster number of the group. ")
    )
    output$downloadData <- downloadHandler(
      filename = paste("SCS-",".png",sep=""),
      content = function(file) {
        ggsave(file,plot=data.pool$dim_p,width=8,height=10)
      }
    )
    })
  })
  
    #cluster差异基因
    observeEvent(input$differ, {  
    output$panel <- renderUI({
      source('tabs/ui/differ.R',local=T)$value
    })
    data.pool$clustnames=as.numeric(levels(data.pool$PBMC@meta.data$seurat_clusters))+1
    updateSelectInput(session,'cls',choices=c(data.pool$clustnames))
    data.pool$marker_gene<- init_differ(data.pool$PBMC,0)
    updateSelectInput(session,'gene',choices=c(data.pool$marker_gene))
    data.pool$new=init_differ_new(data.pool$marker_gene)
    
    observeEvent(input$rec, {
      ident=which(data.pool$clustnames==input$cls)
      data.pool$marker_gene<- init_differ(data.pool$PBMC,ident-1)
        updateSelectInput(session,'gene',choices=c(data.pool$marker_gene))
      data.pool$new=init_differ_new(data.pool$marker_gene)
    })
    sliderValues <- reactive({
      data.frame(
        Name = c("FeaturePlot:"),
        Value = c(input$fea), 
        stringsAsFactors=FALSE
      )
    })
    output$dplot1<-renderPlot(
      FeaturePlot(object = data.pool$PBMC,features =data.pool$marker_gene[sliderValues()$Value[1]:sliderValues()$Value[2]], cols = c("grey", "blue"))
    )
    output$differ1<-renderPrint(
      print("Show the expression level of the marker gene in all cells.  The darker the color is, the higher the expression in the subgroup or cell.")
    )
    output$dplot2<-renderPlotly(
      if(!is.null(input$gene)){
        ggplotly(VlnPlot(data.pool$PBMC, features = input$gene)) #差异基因可视化
      }
    )
    output$differ2<-renderPrint(
      print("The violin diagram visually compares the relative expression levels of marker gene in all subgroups, which can measure the specificity of the gene as a marker gene of a subgroup.")
    )
    output$differ3<-renderTable(
      data.pool$new
    )
    output$download1 <- downloadHandler(
      filename = paste("SCS-",".png",sep=""),
      content = function(file) {
      FeaturePlot(object = data.pool$PBMC,features =data.pool$marker_gene[sliderValues()$Value[1]:sliderValues()$Value[2]], cols = c("grey", "blue"))
        ggsave(file,width=8,height=10)
      }
    )

    output$download2 <- downloadHandler(
      filename = paste("SCS-",".png",sep=""),
      content = function(file) {
        if(!is.null(input$gene)){
          VlnPlot(data.pool$PBMC, features = input$gene)
          ggsave(file,width=8,height=10)
        }
      }
    )

    output$download3 <- downloadHandler(
      filename = function() {
        paste("marker_gene", ".csv", sep = "")
      },
      content = function(file) {
        write.csv(data.pool$markers, file, row.names = FALSE)
      }
    )
  })

    #富集分析
  observeEvent(input$enrich, {
    output$panel <- renderUI({
      source('tabs/ui/enrich.R',local=T)$value
    })    
    updateSelectInput(session,'cls',choices=c(data.pool$clustnames))
    observeEvent(input$submit_enrich,{
        ident=which(data.pool$clustnames==input$cls)
      print(paste(input$cls,"input class"))
      data.pool$cluster.markers <- FindMarkers(object = data.pool$PBMC, ident.1 = ident-1, min.pct = 0.25)
      print(paste("I am in server enrich",input$enrich_way,ident,input$plot_type))
      data.pool$result<-init_enrich(data.pool$cluster.markers,data.pool$sp,input$enrich_way,input$enrich_type,input$enrich_p,input$plot_type)
      if(!is.null(data.pool$result)){
        data.pool$fig<-plot_enrich(data.pool$result,input$enrich_way,input$plot_type)
        output$fig <- renderPlot({
          data.pool$fig
        })
        output$txt <- renderPrint({ 
          data.pool$result
        })

        output$result1<-downloadHandler(
      filename = paste("SCS-",".png",sep=""),
      content = function(file){
        if(!is.null(input$plot_type)){
            data.pool$fig
            ggsave(file,width=8,height=10)
        }
      })

        output$result2 <- downloadHandler( 
          filename=function(){
             paste("enrich",input$enrich_way,ident,input$plot_type,".csv",sep="")
          },
          content=function(file){
             write.csv(data.pool$result,file)
          }) 
      }
    })
    })
})