#' preset_selector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_preset_selector_ui <- function(id){
  ns <- NS(id)
  selectInput(ns("preset_select"),
              "Presets",
              multiple = FALSE,
              choices = c("default")
  )
}

#' preset_selector Server Functions
#'
#' @noRd
mod_preset_selector_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns


    r$presets <- list(
      "default" = list(kdeg = list(value = 0.0017),
                       kd = list(value = 0.001),
                       koff = list(value = 1L),
                       target_c = list(value = 0.1),
                       dose = list(value = 5e-6)
      )
    )

    # When a preset is selected, return corresponding settings
    observeEvent(input$preset_select, {
      r$preset <- r$presets[[input$preset_select]]
      r$simulation_name <- input$preset_select
    })

    observeEvent(input$preset_select,{
      req(input$preset_select != "custom")
      # Also "custom" is removed from list
      updateSelectInput(inputId = "preset_select",
                        choices = names(r$presets),
                        selected = input$preset_select)

    })

    observeEvent(r$parameters, ignoreInit = TRUE, {
      req(input$preset_select != "custom")
      req(r$preset)
      req(r$parameters)

      if (all.equal.list(modifyList(r$parameters, r$preset), r$parameters) != TRUE) {
        updateSelectInput(inputId = "preset_select",
                          choices = c(names(r$presets), "custom"),
                          selected = "custom")
      }
    })

    # When presets are changed (when user save a simulation), then the dropdown is updated.
    observeEvent(r$presets, ignoreInit = TRUE, {
      updateSelectInput(inputId = "preset_select",
                        choices = names(r$presets),
                        selected = r$simulation_name)

    })

  })
}

## To be copied in the UI
# mod_preset_selector_ui("preset_selector_1")

## To be copied in the server
# mod_preset_selector_server("preset_selector_1")
