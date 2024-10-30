#' settings_importer UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_settings_importer_ui <- function(id) {
  ns <- NS(id)
  tooltip(
    fileInput(ns("import_settings"),
      label = "Import",
      buttonLabel = icon("upload"),
      multiple = TRUE,
      accept = ".json",
      width = "50%"
    ),
    title = "Import a `.json` setting file",
    placement = "top"
  )
}

#' settings_importer Server Functions
#'
#' @noRd
mod_settings_importer_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns


    # When file(s) is selected are uploaded using fileInput, read them and
    # add them to the list of presets
    observeEvent(input$import_settings, {
      message("Import setting file(s)")

      tryCatch(
        {

          imported_settings <- read_settings_from_fileInput(input$import_settings)

          generate_toast(
            title = "Settings Imported",
            body = paste(
              "settings",
              paste(names(imported_settings), collapse = ", "),
              "imported successfully"
            ),
            icon = "fas fa-download",
            status = "success"
          )
        },
        error = function(e) {
          generate_toast(
            title = "Import Failed",
            body = paste("Error:", e),
            icon = "fas fa-xmark",
            status = "danger"
          )
        }
      )

      for (preset in names(imported_settings)) {
        r$presets[[preset]] <- imported_settings[[preset]]
      }

      r$last_imported_setting <- preset
    })
  })
}

## To be copied in the UI
# mod_settings_importer_ui("settings_importer_1")

## To be copied in the server
# mod_settings_importer_server("settings_importer_1")

#' Read settings from json files
#'
#' @param file_df the file dataframe returned by import_settings fileInput
#'
#' @return a list of settings
read_settings_from_fileInput <- function(file_df) {
  imported_settings <- list()

  # transform return file df to a list
  file_list <- split(
    x = file_df$datapath,
    f = file_df$name
  )

  for (file_name in names(file_list)) {
    file_settings <- jsonlite::read_json(path = file_list[[file_name]], digits = NA)
    imported_settings <- append(imported_settings, file_settings)
  }
  return(imported_settings)
}
