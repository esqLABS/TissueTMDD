#' sidebar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sidebar_ui <- function(id) {
  ns <- NS(id)
  dashboardSidebar(
    disable = FALSE,
    width = "30%",
    collapsed = FALSE,
    minified = FALSE,
    fixed = TRUE,
    mod_introduction_provider_ui(ns("introduction_provider_1")),
    mod_input_handler_ui(ns("input_handler_1")),
    bs4Dash::box(
      title = "Run Simulation",
      width = 12,
      collapsible = FALSE,
      icon = icon("play"),
      fluidRow(
        column(7, mod_simulation_launcher_ui(ns("simulation_launcher_1"))),
        column(4, mod_simulation_saver_ui(ns("simulation_saver_1"))),
      )
    ),
    bs4Dash::box(
      title = "Compare Simulations",
      width = 12,
      collapsible = FALSE,
      icon = icon("arrow-right-arrow-left"),
      mod_comparison_handler_ui(ns("comparison_handler_1"))
    )
  )
}

#' sidebar Server Functions
#'
#' @noRd
mod_sidebar_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    mod_input_handler_server("input_handler_1", r)
    mod_simulation_launcher_server("simulation_launcher_1", r)
    mod_simulation_saver_server("simulation_saver_1", r)
    mod_comparison_handler_server("comparison_handler_1", r)
  })
}

## To be copied in the UI
#

## To be copied in the server
# mod_sidebar_server("sidebar_1")
