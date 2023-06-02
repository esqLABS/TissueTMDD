#' run_launcher UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_run_launcher_ui <- function(id){
  ns <- NS(id)
    bs4Dash::actionButton(inputId = ns("run_simulation_btn"),
                          label = "Run",
                          icon = icon("play"),
                          width = "100%")
}

#' run_launcher Server Functions
#'
#' @noRd
mod_run_launcher_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns



    observeEvent(input$run_simulation_btn,{
      r$run_simulation <- input$run_simulation_btn
    })

  })
}

## To be copied in the UI
# mod_run_launcher_ui("run_launcher_1")

## To be copied in the server
# mod_run_launcher_server("run_launcher_1")
