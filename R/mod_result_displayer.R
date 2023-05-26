#' result_displayer UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_result_displayer_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' result_displayer Server Functions
#'
#' @noRd 
mod_result_displayer_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_result_displayer_ui("result_displayer_1")
    
## To be copied in the server
# mod_result_displayer_server("result_displayer_1")
