#' settings_exporter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_settings_exporter_ui <- function(id) {
  ns <- NS(id)
  # Hidden button, necessary for download to work
  tagList(
    # Hidden button because download file only works through button
    downloadButton(ns("download_settings"), "Download", style = "visibility: hidden;height: 0px;"),
    fluidRow(
      column(4),
      checkboxInput(ns("export_checkbox"),
        label = "Export Settings",
        width = "33%"
      ),
      column(4)
    )
  )
}

#' settings_exporter Server Functions
#'
#' @noRd
mod_settings_exporter_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(r$save_simulation, {
      if (input$export_checkbox) {
        message("Export Settings to json file")
        # We simulate a click on the hidden "download button"
        click(id = "download_settings")
      }
    })


    output$download_settings <- downloadHandler(
      filename = function() {
        paste(r$simulation_name, "_tissuetmdd_settings", ".json", sep = "")
      },
      content = function(file) {
        tryCatch(
          {
            write(
              get_settings_values_to_json(r$presets[r$simulation_name]),
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
# mod_settings_exporter_ui("settings_exporter_1")

## To be copied in the server
# mod_settings_exporter_server("settings_exporter_1")

get_settings_values_to_json <- function(settings) {
  only_values <- purrr::map(settings, ~ purrr::map(.x, ~ purrr::keep_at(.x, "value")))

  jsonlite::toJSON(only_values,
    pretty = TRUE,
    auto_unbox = TRUE
  )
}
