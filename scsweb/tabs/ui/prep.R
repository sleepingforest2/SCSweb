div(
	sidebarPanel(
		tags$hr(),
		tags$p("STEP2: PREPROPRESS "),
		tags$hr(),
		tags$hr(),
		actionButton("hyva","STEP3 : Hyper Variable")
	),
	mainPanel(
	tabsetPanel(
			tabPanel('Pre-Vlnplot',icon=icon("smile-wink"),plotOutput('prepplot1'),verbatimTextOutput('pre1'),downloadButton("downloadprep1", "Download plot")),
			tabPanel('Pre-process',icon = icon("table"),h1("Summary"),tableOutput('sum1'),verbatimTextOutput('sum2'),downloadButton("downloadsum1", "Download table")),
			tabPanel('After-Vlnplot',icon=icon("smile-wink"),plotOutput('prepplot2'),verbatimTextOutput('pre2'),downloadButton("downloadprep2", "Download plot"))
		),
	)
)