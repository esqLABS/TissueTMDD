#' results_saver UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_results_saver_ui <- function(id){
  ns <- NS(id)
  tagList(
  )
}

#' results_saver Server Functions
#'
#' @noRd
mod_results_saver_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    # When save simulation button is clicked, add simulation name to result_df
    # and save simulation results in r$all_sim_results
    observeEvent(r$save_simulation, {
      req(r$simulation_name)
      req(r$result_df)
      message("Save simulation result as ", r$simulation_name)

      r$result_df$name <- r$simulation_name
      r$all_sim_results[[r$simulation_name]] <-  r$result_df
    })
  })

  # When a preset is loaded, the simulation results are automatically loaded using
  # the name of the preset
  observeEvent(r$result_df, ignoreInit = TRUE, {
    if (r$simulation_name != "custom") {
      isolate(r$result_df$name <- r$simulation_name)
      r$all_sim_results[[r$simulation_name]] <- r$result_df
    }
  })

}

## To be copied in the UI
# mod_results_saver_ui("results_saver_1")

## To be copied in the server
# mod_results_saver_server("results_saver_1")
