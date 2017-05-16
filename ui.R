## ui

library(shiny)
library(shinydashboard)
library(ReporteRs)
options(stringsAsFactors = FALSE)
source("./api_scraper.R")
source("./global.R")

# source("./global.R")

shinyUI(navbarPage("World Bank Project API", theme = "bootstrap.css",
	tabPanel("Single Project",
		fluidRow(
			column(2,
				textInput("pid", label = "Which project do you want to see?"),
				actionButton("spid", "GO!")
			),
			column(8,
				tableOutput("singleproj")
			)
			)
		),
	tabPanel("Mulitple projects",
		fluidRow(
			column(width = 3,
				textInput("pids", "Which projects would you like to see?"),
        selectInput("ord", "Order by", choices = names(orderby)),
				actionButton("mpid", "GO!")
				),
      column(width = 8,
        tableOutput("mprojs"))
			)
		)
	))
