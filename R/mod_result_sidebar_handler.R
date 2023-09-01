#' result_sidebar_handler UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_result_sidebar_handler_ui <- function(id, plot_sidebar_state, choices_output_paths, selected_output_path, selected_y_scale, selected_time_range) {
  ns <- NS(id)
  boxSidebar(
    id = ns("plot_sidebar"),
    width = 33,
    startOpen = plot_sidebar_state,
    h3("Plot Settings"),
    fluidRow(
      column(1),
      selectInput(ns("output_path_select"),
        label = "Output Path to Display",
        choices = choices_output_paths,
        selected = selected_output_path,
        width = "83%"
      ),
      column(1)
    ),
    fluidRow(
      column(1),
      radioButtons(ns("y_scale"),
        label = "Y Scale Type",
        choices = c("log", "linear"),
        selected = selected_y_scale,
        width = "83%"
      ),
      column(1)
    ),
    fluidRow(
      column(1),
      sliderInput(ns("time_range"),
        label = "Time Range",
        min = 0,
        max = 80000,
        value = selected_time_range,
        width = "83%"
      ),
      column(1)
    )
  )
}

#' result_sidebar_handler Server Functions
#'
#' @noRd
mod_result_sidebar_handler_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    r$plot_sidebar_state <- FALSE

    r$plot_settings <- list(
      selected_output_path = defaut_output_paths()[1],
      selected_y_scale = "log",
      selected_time_range = c(0, 80000)
    )


    observeEvent(r$output_paths, {
      if (r$plot_settings$selected_output_path %in% r$output_paths) {
        selected <- r$plot_settings$selected_output_path
      } else {
        selected <- r$output_paths[1]
      }

      updateSelectInput(
        inputId = "output_path_select",
        choices = r$output_paths,
        selected = selected
      )
    })

    observeEvent(input$plot_sidebar, {
      r$plot_sidebar_state <- input$plot_sidebar
    })

    observeEvent(input$output_path_select, {
      r$plot_settings$selected_output_path <- input$output_path_select
    })


    observeEvent(input$y_scale, {
      r$plot_settings$selected_y_scale <- input$y_scale
    })

    observeEvent(input$time_range, {
      r$plot_settings$selected_time_range <- input$time_range
    })
  })
}

## To be copied in the UI
# mod_result_sidebar_handler_ui("result_sidebar_handler_1")

## To be copied in the server
# mod_result_sidebar_handler_server("result_sidebar_handler_1")
