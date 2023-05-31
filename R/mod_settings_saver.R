#' settings_saver UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_settings_saver_ui <- function(id){
  ns <- NS(id)
  tagList(
    actionButton(inputId = ns("save_settings_btn"),
                 label = "Save Settings",
                 icon = icon("save"),
                 width = "100%"),
    # Hidden button, necessary for download to work
    conditionalPanel("false",
                     downloadButton(ns("download_settings"), label = "Download"),
    ))
}

#' settings_saver Server Functions
#'
#' @noRd
mod_settings_saver_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    dataModal <- function(failed = FALSE) {
      modalDialog(title = "Save Simulation",
                  fluidRow(column(1),
                           textInput(ns("simulation_name"),
                                     label = "Simulation Name",
                                     width = "83%"),
                           column(1)),
                  fluidRow(column(4),
                           checkboxInput(ns("export_checkbox"),label = "Export Settings",width = "33%"),
                           column(4)),
                  if (failed)
                    div(tags$b("Please Give a name to the simulation", style = "color: red;")),

                  footer = tagList(
                    fluidRow(modalButton("Cancel", icon = icon("cancel")),
                             actionButton(ns("ok_btn"), "OK",icon = icon("check")))
                  )
      )
    }

    observeEvent(input$save_settings_btn, {
      r$save_settings <- input$save_settings_btn
    })

    observeEvent(r$save_settings,{
      showModal(dataModal())
    })

    observeEvent(input$ok_btn, {
      if (!is.null(input$simulation_name) && nzchar(input$simulation_name)) {
        r$presets[[input$simulation_name]] <- r$parameters
        r$simulation_name <- input$simulation_name
        if (input$export_checkbox) {
          message("downloading settings")
          # We simulate a click on the hidden "download button"
          click(id = "download_settings")
        }
        removeModal()
      } else {
        showModal(dataModal(failed = TRUE))
      }
    })

    output$download_settings <- downloadHandler(
      filename = function() {
        paste("tissuetmdd_settings_", input$simulation_name,".json", sep="")
      },
      content = function(file) {
        to_export <- list()
        # Only values are exported
        to_export[[input$simulation_name]] <- purrr::map(r$presets[[input$simulation_name]],
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
# mod_settings_saver_ui("settings_saver_1")

## To be copied in the server
# mod_settings_saver_server("settings_saver_1")
