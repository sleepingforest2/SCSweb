library(shiny)
shinyUI(fluidPage(
	      titlePanel( 
		     tags$p(h1('Explanation ',tags$small('----you can know more about our analysis process!')))
			 ),
			  tags$br(),
			  navlistPanel(
                  "Click the bottom",
				  tabPanel("Data upload",icon=icon("arrow-alt-circle-up"),tags$img(src="exp1.png",width=750)),
				  tabPanel("Data Source",icon=icon("atom"),tags$img(src="exp2.png",width=750)),
                  tabPanel("Graphic annotation",icon=icon("book"),tags$img(src="exp3.png",width=750)),
				  tabPanel("PCA Parameter setting",icon=icon("calendar-check"),tags$img(src="exp4.png",width=750)),
				  tabPanel("Differential",icon=icon("chess"),tags$img(src="exp5.png",width=750)),
				  tabPanel("Result description",icon=icon("camera-retro"),tags$iframe(frameborder="0",src="062614523788.html",),style = "height:400px;width=100px;"),
				  tabPanel("Contact us",icon=icon("at"),
				  	tags$div(fluidRow(column(3),column(6,
						shiny::HTML("<br><br><center> <h3 style='text-align:center;color:#778899'>
						if you have more questions or suggestions, 
						please contact us ,click the bottom below: </h3> </center><br>"),column(3))),
					fluidRow(column(4),column(4,
						shiny::HTML("<a target='_blank' 
						href='http://mail.qq.com/cgi-bin/qm_share?t=qm_mailme&amp;email=jmeng@njmu.edu.cn' 
						rel='nofollow' style='text-decoration:none;''>
						<img src='http://rescdn.qqmail.com/zh_CN/htmledition/images/function/qm_open/ico_mailme_02.png'></a>"),
					column(4)))))
			)
	)
)