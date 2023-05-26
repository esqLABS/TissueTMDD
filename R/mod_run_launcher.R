#' run_launcher UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_run_launcher_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' run_launcher Server Functions
#'
#' @noRd 
mod_run_launcher_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_run_launcher_ui("run_launcher_1")
    
## To be copied in the server
# mod_run_launcher_server("run_launcher_1")
