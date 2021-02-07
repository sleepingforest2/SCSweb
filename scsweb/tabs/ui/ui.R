library(shiny)
library(shinythemes)
library(shinyWidgets)
library(shinyBS)
library(shinyLP)
shinyUI(
fluidPage(
  tags$head(
      tags$link(rel = "icon", href="logo1.png",sizes="16x16"),
      #-- biblio js ----
      tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
	 
    ),
	style="padding-right:30px;padding-left:0px",
  navbarPage(
  tags$img(
    src='logo.png',width=50,
    style='margin-top:-8px'
  ),
  collapsible=T,
  windowTitle='SCS',
  tabPanel(span(class='glyphicon glyphicon-home',"  HOME"),
   source('tabs/home.R',local=T)$value),
  tabPanel(span(class="glyphicon glyphicon-tags","  Introduction"),
    source('tabs/Introduction.R',local=T)$value),
  tabPanel(span(class="glyphicon glyphicon-tags","  HELP"),
    source('tabs/Help.R',local=T)$value)
  )
  div(
  style="position:absolute;top:1%;left:98%;padding:0",
  dropdownButton(
    inputId = "mydropdown",
    label = "Controls",
    size="xs",
    icon = icon("sliders"),
    status = "primary",
    circle = TRUE,
    shinythemes::themeSelector()))
  )
)