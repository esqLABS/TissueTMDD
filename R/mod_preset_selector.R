#' preset_selector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_preset_selector_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' preset_selector Server Functions
#'
#' @noRd 
mod_preset_selector_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_preset_selector_ui("preset_selector_1")
    
## To be copied in the server
# mod_preset_selector_server("preset_selector_1")
