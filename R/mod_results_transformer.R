#' results_transformer UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_results_transformer_ui <- function(id){
  ns <- NS(id)
}

#' results_transformer Server Functions
#'
#' @noRd
mod_results_transformer_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    observeEvent(r$simulation_results, {
      r$result_df <-
        ospsuite::getOutputValues(r$simulation_results,
                                  quantitiesOrPaths = output_paths()
        )$data
    })

  })
}

## To be copied in the UI
# mod_results_transformer_ui("results_transformer_1")

## To be copied in the server
# mod_results_transformer_server("results_transformer_1")

output_paths <- function(){
  c("Plasma concentration of drug" =  "Organism|PeripheralVenousBlood|Large Molecule Drug|Plasma (Peripheral Venous Blood)",
    "Tissue interstitial concentration of drug" =  "Organism|Skin|Interstitial|Large Molecule Drug|Concentration in container",
    "Target occupancy" = "Organism|Skin|Interstitial|Large Molecule Drug-Target-default Complex|Receptor Occupancy-Large Molecule Drug-Target-default Complex")
}
