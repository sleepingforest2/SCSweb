div(
	sidebarPanel(
		tags$p("STEP7 : MARKER GENE"),
		selectInput('cls','CLUSTER :',c('option')),
		actionButton("rec","REFRESH"),
		tags$hr(),
		sliderInput("fea", "FeaturePlot:",min = 1, max = 20, value = c(1,4)),
		selectInput('gene','Gene Select for VlnPlot-Single:',c('option')),
		tags$hr(),
		actionButton("enrich","STEP8 :  ENRICHMENT ")
	),
	mainPanel(
		tabsetPanel(
			tabPanel('FeaturePlot',plotOutput('dplot1'),verbatimTextOutput('differ1'),downloadButton("download1", "Download plot")),
			tabPanel('VlnPlot-Single',plotlyOutput('dplot2'),verbatimTextOutput('differ2'),downloadButton("download2", "Download plot")),
			tabPanel('Summary',tableOutput('differ3'),
				tags$p("if you want to see all genes ,you can download this table "),
				downloadButton("download3", "Download table"))
		)
	)
)