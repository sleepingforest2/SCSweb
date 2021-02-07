div(
   fluidRow(column(12,
      div(
	      h1('Single-cell-sequencing ',tags$small('Introduction')),
		  style='margin-top:-10px;background-color:#9DC3E6;padding:5px;color:#FFF;border-radius:10px;text-align:center'
        ))),
	fluidRow(column(12,
	  div(
	     h3('Development status'))
	)),
	fluidRow(column(4,
	  div(
         img(src='book.png',width=450))),
	        column(8,
	  div(
		   p('		The difference between single cell sequencing and ordinary sequencing is that the RNA 
		   (or DNA) extracted from ordinary sequencing comes from multiple cells in the sample, 
		   so the results of ordinary sequencing will inevitably be affected by the heterogeneity 
		   between different cells, while single cell sequencing is aimed at sequencing the genome
		   of a single cell, which can better help us understand the differences between cells.')
		   ))
	),
	fluidRow(column(4,
	  div(
		 h3('Sequencing principle')),
	  div(
		 class='panel-body',
		 img(src='principle.png',width=300))),
	        column(8,
	  div(
		 h3('Sequencing process')),
	  div(
		 class='panel-body',
		 img(src='analysis_show.png',width=800,style='margin-top:25px')))),
	fluidRow(column(12,
	   div(
	    h3('Source',tags$a(href="https://support.10xgenomics.com/single-cell-gene-expression/datasets", 
		           tags$small('----Get more Dataset to try our platform!') ))
	   )))
)

