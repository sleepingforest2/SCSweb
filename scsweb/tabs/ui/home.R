tags$div(
    fluidRow(column(12,div(
    class='jumbotron',display='grid',
    style='background-color:#9DC3E6;color:#FFF',
    h1('Bio- ',tags$small('analysis of SCS results',style='color:#FFF;text-align:left;margin-top:-15px;font-weight:normal;font-size:40px'),
       style='color:#FFF;text-align:left;margin-top:-15px;font-weight:bold;font-size:80px'
	   ),
    div(tags$p('A young low-key single cell sequencing and analysis platform',style='color:#FFF;text-align:left;font-size:25px')),
		style='margin-left:-30px;margin-top:5px'
  ))),
    fluidRow(
	 column(12,tags$hr(),style="margin-top:-20px")
	),
    
    fluidRow(
	   column(2,div(
                    img(src='logo_show.jpg',width=130,style='margin-left:30px'),
					h2('  Analysis',style='color:#A6A6A6;margin-left:40px'),
                    h2('  Process',style='color:#A6A6A6;margin-left:40px'),
					style="margin-top:-5px"
               )
		      ),
	   column(7,div(
                   img(src='analysis_process.png',width=850),  
				   style='margin-top:-5px'
        )),
	   column(3,
	   div(
	       div(h3("Devices we support",style='margin-top:20px')),
		   div(img(src="device.png",width=700,style='margin-top:30px'))))
	)			   
)