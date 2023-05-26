#' body UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_body_ui <- function(id){
  ns <- NS(id)
    dashboardBody(
      # Boxes need to be put in a row (or column)
      fluidRow(
        box(plotOutput("plot1", height = 250)),

        box(
          title = "Controls",
          sliderInput("slider", "Number of observations:", 1, 100, 50)
        )
      )
    )
}

#' body Server Functions
#'
#' @noRd
mod_body_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
#

## To be copied in the server
# mod_body_server("body_1")
