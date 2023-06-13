#' simulation_saver UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_simulation_saver_ui <- function(id) {
  ns <- NS(id)
  tooltip(
    actionButton(
      inputId = ns("save_simulation_btn"),
      label = "Save",
      icon = icon("save"),
      width = "100%"
    ),
    title = "Save simulation settings and results",
    placement = "top"
  )
}

#' simulation_saver Server Functions
#'
#' @noRd
mod_simulation_saver_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns


    mod_settings_exporter_server("settings_exporter_1", r)

    # Disable save button when there is not simulation data
    observeEvent(r$result_df, ignoreNULL = FALSE, {
      if (is.null(r$result_df)) {
        shinyjs::disable("save_simulation_btn")
      } else {
        shinyjs::enable("save_simulation_btn")
      }
    })

    # Display modal when button is clicked
    observeEvent(input$save_simulation_btn, {
      showModal(
        generate_modal()
      )
    })

    # Save settings and close modal when confirm button is clicked if
    # simulation_name is not empty, otherwise, warn the user.
    observeEvent(input$confirm, {
      if (!is.null(input$simulation_name) && nzchar(input$simulation_name)) {
        r$presets[[input$simulation_name]] <- r$parameters
        r$simulation_name <- input$simulation_name
        r$save_simulation <- Sys.time()
        removeModal()
      } else {
        showModal(generate_modal(failed = TRUE))
      }
    })

    generate_modal <- function(failed = FALSE) {
      modalDialog(
        title = "Save Simulation Settings",
        fluidRow(
          column(1),
          textInput(ns("simulation_name"),
            label = "Simulation Name",
            width = "83%"
          ),
          column(1)
        ),
        mod_settings_exporter_ui(ns("settings_exporter_1")),
        if (failed) {
          fluidRow(
            column(8,
              offset = 2,
              bs4Dash::callout("Please Give a name to the simulation",
                title = "No simulation name",
                status = "danger", width = 12
              )
            )
          )
        },
        footer = tagList(
          fluidRow(
            modalButton("Cancel", icon = icon("cancel")),
            actionButton(ns("confirm"), "OK", icon = icon("check"))
          )
        )
      )
    }
  })
}

## To be copied in the UI
# mod_simulation_saver_ui("simulation_saver_1")

## To be copied in the server
# mod_simulation_saver_server("simulation_saver_1")
