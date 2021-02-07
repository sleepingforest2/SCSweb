div(
	sidebarPanel(
		tags$hr(),
		tags$p("STEP1: NORMALIZATION "),
		tags$hr(),
		tags$hr(),
		actionButton("prep","STEP2 : PREPROPRESS")

	),
	mainPanel(
	tabsetPanel(
			tabPanel('Gene_distrubtion',icon=icon("smile-wink"),plotlyOutput('histplot1'),verbatimTextOutput('hist1'),downloadButton("downloadhist1", "Download plot")),
			tabPanel('Barcode_distrubtion',icon=icon("smile-wink"),plotlyOutput('histplot2'),verbatimTextOutput('hist2'),downloadButton("downloadhist2", "Download plot"))
		)
	)
)