#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @import shinipsum
#' @import esqlabsR
#' @import ggplot2
#' @import tidyr
#' @import dplyr
#' @import purrr
#' @import magrittr
#' @import jsonlite
#' @import shinyjs
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  r <- reactiveValues()

  mod_sidebar_server("sidebar_1", r)
  mod_body_server("body_1", r)
  mod_simulation_runner_server("simulation_runner_1", r)
  mod_results_transformer_server("results_transformer_1", r)
}
