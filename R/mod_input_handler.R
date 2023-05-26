#' input_handler UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_input_handler_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' input_handler Server Functions
#'
#' @noRd 
mod_input_handler_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_input_handler_ui("input_handler_1")
    
## To be copied in the server
# mod_input_handler_server("input_handler_1")
