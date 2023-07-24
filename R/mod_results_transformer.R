#' results_transformer UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_results_transformer_ui <- function(id) {
  ns <- NS(id)
}

#' results_transformer Server Functions
#'
#' @noRd
mod_results_transformer_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(r$simulation_results, {
      result_df <- ospsuite::simulationResultsToDataFrame(r$simulation_results[[1]][[1]])

      result_df$name <- r$simulation_name

      r$result_df <- result_df
    })
  })
}

## To be copied in the UI
# mod_results_transformer_ui("results_transformer_1")

## To be copied in the server
# mod_results_transformer_server("results_transformer_1")
