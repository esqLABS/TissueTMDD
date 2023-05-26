#' settings_saver UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_settings_saver_ui <- function(id){
  ns <- NS(id)
  tagList(
 
  )
}
    
#' settings_saver Server Functions
#'
#' @noRd 
mod_settings_saver_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_settings_saver_ui("settings_saver_1")
    
## To be copied in the server
# mod_settings_saver_server("settings_saver_1")
