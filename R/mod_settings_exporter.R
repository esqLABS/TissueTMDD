#' settings_exporter UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_settings_exporter_ui <- function(id){
  ns <- NS(id)
  # Hidden button, necessary for download to work
  tagList(
    fluidRow(column(4),
             checkboxInput(ns("export_checkbox"),
                           label = "Export Settings",
                           width = "33%"),
             column(4)),
    # Hidden button because download file only works through button
    downloadButton(ns("download_settings"), "Download", style = "visibility: hidden;")
  )
}

#' settings_exporter Server Functions
#'
#' @noRd
mod_settings_exporter_server <- function(id, r){
  moduleServer( id, function(input, output, session){
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
        paste(r$simulation_name, "_tissuetmdd_settings", ".json", sep="")
      },
      content = function(file) {
        to_export <- list()
        # Only values are exported
        to_export[[r$simulation_name]] <- purrr::map(r$presets[[r$simulation_name]],
                                                     ~purrr::keep_at(.x, "value"))
        write(jsonlite::toJSON(to_export,
                               pretty = TRUE,
                               auto_unbox = TRUE),
              file)
      }
    )



  })
}

## To be copied in the UI
# mod_settings_exporter_ui("settings_exporter_1")

## To be copied in the server
# mod_settings_exporter_server("settings_exporter_1")
