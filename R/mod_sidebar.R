#' sidebar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sidebar_ui <- function(id){
  ns <- NS(id)
  dashboardSidebar(disable = FALSE,
                   width = "30%",
                   collapsed = FALSE,
                   minified = FALSE,
                   fixed = TRUE,
                   mod_introduction_provider_ui(ns("introduction_provider_1")),
                   mod_input_handler_ui(ns("input_handler_1")),
                   fluidRow(
                     column(7, mod_run_launcher_ui(ns("run_launcher_1"))),
                     column(4, mod_settings_saver_ui(ns("settings_saver_1"))),
                   )

  )
}

#' sidebar Server Functions
#'
#' @noRd
mod_sidebar_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    mod_input_handler_server("input_handler_1", r)
    mod_run_launcher_server("run_launcher_1", r)
    mod_settings_saver_server("settings_saver_1", r)
  })
}

## To be copied in the UI
#

## To be copied in the server
# mod_sidebar_server("sidebar_1")
