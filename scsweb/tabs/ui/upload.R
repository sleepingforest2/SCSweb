tags$div(
	sidebarPanel(
		#file input
		fileInput("raw","UPLOAD DATA",accept=c('*','*')),
		tags$h5("Upload compressed file(gz,zip), also less than 15MB"),
		tags$a(href="GSE117988_raw.expMatrix_PBMC.csv.gz" ,download="GSE117988_raw.expMatrix_PBMC.csv.gz",
		       tags$h5('Sample1:Homo sapiens') ),
		tags$a(href="GSM4354862.csv.gz" ,download="GSM4354862.csv.gz",
		       tags$h5('Sample2:Mouse') ),
		tags$hr(),
		radioButtons("sp", "Choose data source species:",c("Homo sapiens" = "human","Mouse"= "mouse")),
        tags$hr(),
		actionButton("norm","STEP1 : Normalization")
	),
	mainPanel(
			tags$img(src="f.png",height=500,width=800)
		)
)