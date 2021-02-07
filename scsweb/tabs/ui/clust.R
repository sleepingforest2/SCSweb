div(
	sidebarPanel(
		tags$hr(),
		tags$p("STEP5: CELL CLUST "),
		tags$hr(),
		tags$hr(),
		actionButton("tsne","STEP6 : TSNE & UMAP"),
		tags$hr(),
		tags$hr(),
	),
	mainPanel(
	tabsetPanel(
			tabPanel('Pie',icon=icon("smile-wink"),plotOutput('panplotResult'),verbatimTextOutput('clust'),downloadButton("downloadpan", "Download plot"))
			)
	)	
)