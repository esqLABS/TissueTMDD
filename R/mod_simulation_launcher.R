#' simulation_launcher UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_simulation_launcher_ui <- function(id){
  ns <- NS(id)
  tooltip(
  bs4Dash::actionButton(inputId = ns("run_simulation_btn"),
                        label = "Run",
                        icon = icon("play"),
                        width = "100%"),
  title = "Use this button to start the simulation",
  placement = "top")
}

#' simulation_launcher Server Functions
#'
#' @noRd
mod_simulation_launcher_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    observeEvent(input$run_simulation_btn, {
      req(r$plot_id)

      start_loading_bar(r, target_id = r$plot_id)

      message("Run simulation")
      r$simulation_results <- ospsuite::runSimulation(r$model)
    })

  })
}

## To be copied in the UI
# mod_simulation_launcher_ui("simulation_launcher_1")

## To be copied in the server
# mod_simulation_launcher_server("simulation_launcher_1", r)
