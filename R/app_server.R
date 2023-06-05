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
#' @import waiter
#' @noRd
app_server <- function(input, output, session) {
  # Your application server logic

  r <- reactiveValues()

  mod_sidebar_server("sidebar_1", r)
  mod_body_server("body_1", r)

  # Backend modules
  mod_model_loader_server("model_loader_1", r)
  mod_data_loader_server("data_loader_1", r)
  mod_results_transformer_server("results_transformer_1", r)
  mod_results_saver_server("results_saver_1", r)
}
