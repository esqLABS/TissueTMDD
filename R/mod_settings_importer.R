#' settings_importer UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_settings_importer_ui <- function(id){
  ns <- NS(id)
  tagList(
    fileInput(ns("import_settings"),
              label = "Import",
              buttonLabel = icon("upload"),
              multiple = TRUE,
              accept = ".json",
              width = "50%")
  )
}

#' settings_importer Server Functions
#'
#' @noRd
mod_settings_importer_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(input$import_settings,{
      for (file in input$import_settings$datapath) {
        json_data <- jsonlite::read_json(path = file)
        for (name in names(json_data)) {
          r$presets[[name]] <- json_data[[name]]
          showNotification(ui = paste(name, "settings was imported successfully"),
                           type = "message")
        }
      }
    })

  })
}

## To be copied in the UI
# mod_settings_importer_ui("settings_importer_1")

## To be copied in the server
# mod_settings_importer_server("settings_importer_1")
