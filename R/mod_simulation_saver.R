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
    bs4Dash::actionButton(
      inputId = ns("save_simulation_btn"),
      label = "Save",
      icon = icon("save"),
      size = "lg",
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

    # Disable save button when there is not simulation data
    observeEvent(r$result_df, ignoreNULL = FALSE, {
      if (is.null(r$result_df)) {
        updateActionButton(inputId = "save_simulation_btn", disabled = TRUE)
      } else {
        updateActionButton(inputId = "save_simulation_btn", disabled = FALSE)
      }
    })


    # Display modal when button is clicked
    observeEvent(input$save_simulation_btn, {
      showModal(
        generate_modal()
      )

      addTooltip(
        id = "export-checkbox-tooltip",
        options = list(title = "Export the settings to a json file")
      )
    })

    # Save settings and close modal when confirm button is clicked if
    # simulation_name is not empty, otherwise, warn the user.
    observeEvent(input$confirm, {
      if (!is.null(input$simulation_name) && nzchar(input$simulation_name) && input$simulation_name != "custom") {
        r$simulation_name <- input$simulation_name
        r$last_saved_simulation <- r$simulation_name
        r$presets[[r$simulation_name]] <- r$input_list
        r$save_simulation <- Sys.time()
        removeModal()
      } else {
        showModal(generate_modal(failed = TRUE))
      }
    })

    # Modal generation function
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
        # Hidden button because download file only works through button
        downloadButton(ns("download_settings"), "Download", style = "visibility: hidden;height: 0px;"),
        fluidRow(
          column(4),
          checkboxInput(ns("export_checkbox"),
            label = list("Export Settings", tooltip(
              span(bsicons::bs_icon("info-circle"),
                id = "export-checkbox-tooltip"
              ),
              title = "Export the settings to a json file"
            )),
            width = "33%"
          ),
          column(4)
        ),
        # mod_settings_exporter_ui(ns("settings_exporter_1")),
        if (failed) {
          fluidRow(
            column(8,
              offset = 2,
              bs4Dash::callout("Please Give a name to the simulation (different than 'custom')",
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

    # When the save_simulation button is clicked, export the settings to a json file
    observeEvent(r$save_simulation, {
      if (input$export_checkbox) {
        message("Export Settings to json file")
        # We simulate a click on the hidden "download button"
        click(id = "download_settings")
      }
    })

    # Download the settings to a json file
    output$download_settings <- downloadHandler(
      filename = function() {
        paste(r$simulation_name, "_tissuetmdd_settings", ".json", sep = "")
      },
      content = function(file) {
        tryCatch(
          {
            write(
              get_settings_values_to_json(r$simulation_name, r$presets[[r$simulation_name]]),
              file
            )
            generate_toast(
              title = "Settings Exported",
              body = paste(r$simulation_name, "successfully exported to json file"),
              icon = "fas fa-upload",
              status = "success"
            )
          },
          error = function(e) {
            generate_toast(
              title = "Settings Export Failed",
              body = paste("Error:", e),
              icon = "fas fa-xmak",
              status = "danger"
            )
          }
        )
      }
    )
  })
}

## To be copied in the UI
# mod_simulation_saver_ui("simulation_saver_1")

## To be copied in the server
# mod_simulation_saver_server("simulation_saver_1")

get_settings_values_to_json <- function(simulation_name, settings) {
  only_values <- purrr::map(settings, ~ purrr::keep_at(.x, "value"))

  to_export <- list()

  to_export[[simulation_name]] <- only_values

  jsonlite::toJSON(to_export,
    pretty = TRUE,
    auto_unbox = TRUE,
    digits = NA
  )
}
