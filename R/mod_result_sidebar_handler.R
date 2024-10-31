#' result_sidebar_handler UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_result_sidebar_handler_ui <- function(id) {
  ns <- NS(id)
  boxSidebar(
    id = ns("plot_sidebar"),
    width = 33,
    startOpen = FALSE,
    h3("Plot Settings"),
    fluidRow(
      column(1),
      selectInput(ns("output_path_select"),
        label = "Output Path to Display",
        choices = NA_character_,
        selected = NA_character_,
        width = "83%"
      ),
      column(1)
    ),
    fluidRow(
      column(1),
      radioButtons(ns("y_scale"),
        label = "Scale type (Y-axis)",
        choices = c("log", "linear"),
        selected = "log",
        width = "83%"
      ),
      column(1)
    ),
    fluidRow(
      column(1),
      selectInput(ns("time_unit"),
        label = "Time Unit",
        choices = c("Hours", "Days"),
        selected = "Hours",
        width = "83%"
      ),
      column(1)
    ),
    fluidRow(
      column(1),
      sliderInput(ns("time_range"),
        label = textOutput(ns("time_range_label")),
        min = 0,
        max = 100,
        value = c(0, 100),
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

    r$plot_settings <- reactiveValues(
      selected_output_path = defaut_output_paths()[1],
      selected_y_scale = "log",
      selected_time_unit = "Days",
      selected_time_range = c(0, 100),
      time_range_limits = c(0, 100)
    )


    # Observers: Data --> Inputs

    # Update output path select input when simulation data is available
    observeEvent(r$display_df, {
      if (is.null(input$output_path_select) || !(input$output_path_select %in% r$output_paths)) {
        selected <- r$output_paths[1]
      } else if (input$output_path_select %in% r$output_paths) {
        selected <- input$output_path_select
      }

      updateSelectInput(
        inputId = "output_path_select",
        choices = r$output_paths,
        selected = selected
      )
    })

    # Update time range slider when simulation data and transformed to selected time unit
    observeEvent(r$result_df_time_transformed, {
      time_range_limits <- range(r$result_df_time_transformed$Time)

      updateSliderInput(
        inputId = "time_range",
        min = floor(time_range_limits[1]),
        max = ceiling(time_range_limits[2]),
        value = time_range_limits
      )
    })

    # Observers: Inputs --> Data

    # Transform Time column depending on the time unit selected by user
    observe({
      req(r$display_df)
      req(input$time_unit)

      time_unit_duration <-
        if (input$time_unit == "Days") {
          lubridate::ddays(1)
        } else if (input$time_unit == "Hours") {
          lubridate::dhours(1)
        }

      r$result_df_time_transformed <-
        dplyr::mutate(r$display_df,
          Time = lubridate::duration(Time, units = unique(r$display_df$TimeUnit)) / time_unit_duration
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

    observeEvent(input$time_unit, {
      r$plot_settings$selected_time_unit <- input$time_unit
    })

    observeEvent(input$time_range, {
      r$plot_settings$selected_time_range <- input$time_range
    })


    output$time_range_label <- renderText({
      glue::glue("Time Range ({input$time_unit})")
    })
  })
}

## To be copied in the UI
# mod_result_sidebar_handler_ui("result_sidebar_handler_1")

## To be copied in the server
# mod_result_sidebar_handler_server("result_sidebar_handler_1")
