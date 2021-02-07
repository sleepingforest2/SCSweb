div(
	sidebarPanel(
		tags$hr(),
		tags$p("STEP3 : Hyper Variable "),
		tags$hr(),
		tags$hr(),
		actionButton("pca","STEP4 : PCA")
	),
	mainPanel(
	tabsetPanel(
			tabPanel('Dimplot',icon=icon("smile-wink"),plotOutput('hyvaplot'),verbatimTextOutput('hyva'),downloadButton("downloadhyva", "Download plot"))
		)
	)
)