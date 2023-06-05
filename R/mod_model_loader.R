#' model_loader UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_model_loader_ui <- function(id){
  ns <- NS(id)
  tagList(

  )
}

#' model_loader Server Functions
#'
#' @noRd
mod_model_loader_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    r$model <- load_default_model()

  })
}

## To be copied in the UI
# mod_model_loader_ui("model_loader_1")

## To be copied in the server
# mod_model_loader_server("model_loader_1")

load_default_model <- function() {
  simulation_path <- system.file("extdata", "Large molecule Human default.pkml",
                                 package = "TissueTMDD",
                                 mustWork = TRUE)
  model <- ospsuite::loadSimulation(simulation_path)
  message("Load model file")
  return(model)
}

