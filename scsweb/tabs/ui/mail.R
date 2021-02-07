div(
	#setBackgroundColor("blue"),
	class="panel-body",
	align = "center",
	style='background-color:#9DC3E6;color:#FFF;',
	fileInput("raw2",h4("UPLOAD DATA",style="font-size:20px"),accept=c('*','*')),
	tags$h4("Upload compressed file(gz,zip), also less than 15MB",style="font-size:20px"),
	radioButtons("sp2", h4("Choose data source species:",style="font-size:20px"),
		c("Human"= "human","Mouse"= "mouse")),
	textInput("email", h4("Edit email",style="font-size:20px"), value = "Enter email..."),
	textInput("fname", h4("Edit file name",style="font-size:20px"), value = ""),
	actionButton("email_sub","Submit")
)