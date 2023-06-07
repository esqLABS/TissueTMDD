#' result_sidebar_handler UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_result_sidebar_handler_ui <- function(id, selected_output_path, selected_y_scale){
  ns <- NS(id)
  boxSidebar(
    id = ns("plot-sidebar"),
    width = 33,
    h3("Plot Settings"),
    fluidRow(column(1),
             selectInput(ns("output_path_select"),
                         label = "Output Path to Display",
                         choices = output_paths(),
                         selected = selected_output_path,
                         width = "83%"),
             column(1)),
    fluidRow(column(1),
             radioButtons(ns("y_scale"),
                         label = "Scale Type",
                         choices = c("log", "linear"),
                         selected = selected_y_scale),
             column(1)),
  )
}

#' result_sidebar_handler Server Functions
#'
#' @noRd
mod_result_sidebar_handler_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    r$plot_settings <- list(selected_output_path = output_paths()[1],
                            selected_y_scale = "log")

    observeEvent(input$output_path_select, {
      r$plot_settings$selected_output_path <- input$output_path_select
    })


    observeEvent(input$y_scale, {
      r$plot_settings$selected_y_scale <- input$y_scale
    })

  })
}

## To be copied in the UI
# mod_result_sidebar_handler_ui("result_sidebar_handler_1")

## To be copied in the server
# mod_result_sidebar_handler_server("result_sidebar_handler_1")
