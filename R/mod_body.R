#' body UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_body_ui <- function(id) {
  ns <- NS(id)
  dashboardBody(
    mod_result_displayer_ui(ns("result_displayer_1"))
  )
}

#' body Server Functions
#'
#' @noRd
mod_body_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    mod_result_displayer_server("result_displayer_1", r)
  })
}

## To be copied in the UI
#

## To be copied in the server
# mod_body_server("body_1")
