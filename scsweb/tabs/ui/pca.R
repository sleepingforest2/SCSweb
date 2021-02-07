div(
	sidebarPanel(
		tags$hr(),
		tags$p("STEP4: PCA "),
		sliderInput("dim1", "VizDimLoadings:",min = 1, max = 20, value = c(1,4)),
		sliderInput("dim2", "DimHeatmap:",min = 1, max = 20, value = c(1,6)),
		actionButton("refresh","REFRESH"),
		tags$hr(),
		sliderInput("dimpca", "select PCA for step5:",min = 1, max = 20, value = c(1,10)),
		tags$hr(),
		actionButton("clust","STEP5 : CELL CLUST")
	),
	mainPanel(
	tabsetPanel(
			tabPanel('Dimplot',icon=icon("smile-wink"),plotlyOutput('PCA1'),verbatimTextOutput('pca1'),downloadButton("downloadDim", "Download plot")),
			tabPanel('ElbowPlot',icon=icon("smile-wink"),plotlyOutput('PCA2'),verbatimTextOutput('pca2'),downloadButton("downloadelbow", "Download plot")),
			tabPanel('VizDimLoadings',icon=icon("smile-wink"),plotOutput('PCA3'),verbatimTextOutput('pca3'),downloadButton("downloadviz", "Download plot")),
			tabPanel('DimHeatmap',icon=icon("smile-wink"),plotOutput('PCA4'),verbatimTextOutput('pca4'),downloadButton("downloadheat", "Download plot"))
		)
	)
)