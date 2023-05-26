#' comparison_handler UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_comparison_handler_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' comparison_handler Server Functions
#'
#' @noRd 
mod_comparison_handler_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_comparison_handler_ui("comparison_handler_1")
    
## To be copied in the server
# mod_comparison_handler_server("comparison_handler_1")
