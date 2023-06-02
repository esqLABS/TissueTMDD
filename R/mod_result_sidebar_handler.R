#' result_sidebar_handler UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_result_sidebar_handler_ui <- function(id){
  ns <- NS(id)
  boxSidebar(
    id = ns("plot-sidebar"),
    width = 33,
    h3("Plot Settings"),
    fluidRow(column(1),
             selectInput(ns("output_path_select"),
                         label = "Output Path to Display",
                         choices = output_paths(),
                         width = "83%"),
             column(1)),
    fluidRow(column(1),
             radioButtons(ns("yaxis_scale"),
                         label = "Scale Type",
                         choices = c("log", "linear"),
                         selected = "log"),
             column(1)),
  )
}

#' result_sidebar_handler Server Functions
#'
#' @noRd
mod_result_sidebar_handler_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    r$plot_settings <- list()

    observeEvent(input$output_path_select, {
      r$plot_settings$output_path_select <- input$output_path_select
    })


    observeEvent(input$yaxis_scale, {
      r$plot_settings$yaxis_scale <- input$yaxis_scale
    })

  })
}

## To be copied in the UI
# mod_result_sidebar_handler_ui("result_sidebar_handler_1")

## To be copied in the server
# mod_result_sidebar_handler_server("result_sidebar_handler_1")
