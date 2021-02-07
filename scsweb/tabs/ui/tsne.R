div(
	sidebarPanel(
		tags$hr(),
		tags$p("STEP6: TSNE & UMAP"),
		tags$hr(),
		selectInput('reduction','Select for dimensionality reduction:',c('tsne','UMAP'),selected='tsne'),
		actionButton("ref_tsne","Submit"),
		tags$hr(),
		tags$hr(),
		actionButton("differ","STEP7 : MARKER GENE")
	),
	mainPanel(
	tabsetPanel(
			tabPanel('Dimplot',icon=icon("smile-wink"),plotlyOutput('tplot'),verbatimTextOutput('tsne'))
		),
	downloadButton("downloadData", "Download plot"))
)