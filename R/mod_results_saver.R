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

    observeEvent(r$save_settings,{
      req(r$result_df)
      req(r$simulation_name)
      r$all_sim_results[[r$simulation_name]] <- r$result_df
    })
  })
}

## To be copied in the UI
# mod_results_saver_ui("results_saver_1")

## To be copied in the server
# mod_results_saver_server("results_saver_1")
