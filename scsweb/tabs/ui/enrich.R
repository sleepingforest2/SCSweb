div(
	sidebarPanel(
		tags$p("STEP8 : ENRICHMENT"),
		selectInput('cls','CLUSTER :',c('option')), 
		selectInput('enrich_way',"Choose Enrichment analysis approaches",c('GO'='GO','KEGG'='KEGG'),selected='GO'),
		conditionalPanel(
			condition="input.enrich_way=='GO'",
			selectInput(inputId="enrich_type",label="Select enrich type",choices=c('BP','MF','CC','ALL'),selected='BP'),
			numericInput('enrich_p',"P_value",0.5,min=0,max=1),
			radioButtons('plot_type',"Plot Option",c(point=1,bar=0))
	    ),
		conditionalPanel(
			condition="input.enrich_way=='KEGG'",
			numericInput('enrich_p',"P_value",0.5,min=0,max=1),
			radioButtons('plot_type',"Plot Option",c(point=1,bar=0))
	    ),
		actionButton("submit_enrich","Submit for Enrichment")
	),
	mainPanel(
		tabsetPanel(
			tabPanel('Enrich Plot',icon=icon("smile-wink"),plotOutput("fig"),downloadButton("result1","Download")),
			tabPanel('Enrich result',icon=icon("smile-wink"),verbatimTextOutput("txt"),downloadButton("result2", "Download"))
		)
	)
)