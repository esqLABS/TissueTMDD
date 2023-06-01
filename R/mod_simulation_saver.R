#' simulation_saver UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_simulation_saver_ui <- function(id){
  ns <- NS(id)
  actionButton(inputId = ns("save_simulation_btn"),
               label = "Save",
               icon = icon("save"),
               width = "100%")
}

#' simulation_saver Server Functions
#'
#' @noRd
mod_simulation_saver_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    mod_settings_exporter_server("settings_exporter_1", r)



    observeEvent(input$save_simulation_btn, {
      showModal(dataModal())
    })

    dataModal <- function(failed = FALSE){
      modalDialog(title = "Save Simulation Settings",
                  fluidRow(column(1),
                           textInput(ns("simulation_name"),
                                     label = "Simulation Name",
                                     width = "83%"),
                           column(1)),
                  mod_settings_exporter_ui(ns("settings_exporter_1")),
                  if (failed)
                    div(tags$b("Please Give a name to the simulation", style = "color: red;")),

                  footer = tagList(
                    fluidRow(modalButton("Cancel", icon = icon("cancel")),
                             actionButton(ns("ok_btn"), "OK",icon = icon("check")))
                  )
      )
    }

    observeEvent(input$ok_btn, {
      if (!is.null(input$simulation_name) && nzchar(input$simulation_name)) {
        r$presets[[input$simulation_name]] <- r$parameters
        r$simulation_name <- input$simulation_name
        r$save_simulation <- Sys.time()
        removeModal()
      } else {
        showModal(dataModal(failed = TRUE))
      }
    })

  })
}

## To be copied in the UI
# mod_simulation_saver_ui("simulation_saver_1")

## To be copied in the server
# mod_simulation_saver_server("simulation_saver_1")
