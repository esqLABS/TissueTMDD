#' simulation_runner UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_simulation_runner_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' simulation_runner Server Functions
#'
#' @noRd
mod_simulation_runner_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    r$model <- load_default_model()



    observeEvent(r$run_simulation, {
      message("Run simulation")
      r$simulation_results <- ospsuite::runSimulation(r$model)
    })

  })
}

## To be copied in the UI
# mod_simulation_runner_ui("simulation_runner_1")

## To be copied in the server
# mod_simulation_runner_server("simulation_runner_1")


load_default_model <- function() {
  simulation_path <- system.file("extdata", "Large molecule Human default.pkml",
                                 package = "TissueTMDD",
                                 mustWork = TRUE)
  model <- ospsuite::loadSimulation(simulation_path)
  message("Load model file")
  return(model)
}

