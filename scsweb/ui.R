library(shiny)
library(shinyWidgets)
library(shinythemes)
shinyUI(
fluidPage(
  tags$head(
      tags$link(rel = "icon", href="logo1.png",sizes="16x16"),
      #-- biblio js ----
      tags$link(rel = "stylesheet", type = "text/css", href = "bootstrap.css")
    ),
  style="padding:0",
  navbarPage(
  tags$img(
    src='logo.png',width=50,
    style='margin-top:-8px'
  ),
  tabPanel(span(class='glyphicon glyphicon-home',"  HOME"),
   source('tabs/ui/home.R',local=T)$value),
  navbarMenu("  ANALYSIS",
  tabPanel(span(class="glyphicon glyphicon-equalizer","  BackStage ANALYSIS"),source('tabs/ui/mail.R',local=T)$value),
  tabPanel(span(class="glyphicon glyphicon-equalizer","  ONLINE ANALYSIS"),uiOutput("panel"))),
  tabPanel(span(class="glyphicon glyphicon-globe","  INTRODUCTION"),
    source('tabs/ui/Introduction.R',local=T)$value),
  tabPanel(span(class="glyphicon glyphicon-tags","  HELP"),
    source('tabs/ui/Help.R',local=T)$value),
  collapsable=T,
  windowTitle='SCS')
))