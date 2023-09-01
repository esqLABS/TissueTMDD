#' preset_selector UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_preset_selector_ui <- function(id) {
  ns <- NS(id)
  tooltip(
    selectInput(ns("preset_select"),
      "Presets",
      multiple = FALSE,
      choices = c("default"),
      width = "50%"
    ),
    "Preconfigured settings",
    "top"
  )
}

#' preset_selector Server Functions
#'
#' @noRd
mod_preset_selector_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    r$presets <- reactiveValues(
      "default" = purrr::map(default_parameters(), ~ purrr::keep_at(.x, "value"))
    )

    observeEvent(r$parameters, ignoreInit = TRUE, {
      req(input$preset_select != "custom")
      req(r$preset)
      req(r$parameters)

      # If current settings are different than the selected preset, then switch to "custom"
      if (!identical(modifyList(r$parameters, r$preset), r$parameters)) {
        updateSelectInput(
          inputId = "preset_select",
          choices = c(names(r$presets), "custom"),
          selected = "custom"
        )
        r$simulation_name <- "custom"
      }
    })

    # When a preset is selected, return corresponding settings,
    # set simulation name to the selected preset and load existing simulation
    # results if available
    observeEvent(input$preset_select, {
      req(input$preset_select)
      req(r$all_sim_results)

      # load preset settings
      r$preset <- r$presets[[input$preset_select]]

      # if (input$preset_select != "custom") {
      # set simulation name
      r$simulation_name <- input$preset_select

      if (input$preset_select %in% names(r$all_sim_results)) {
        # load stored results
        r$result_df <- r$all_sim_results[[input$preset_select]]
      } else {
        # reset result_df
        r$result_df <- NULL
      }
      # }
    })


    # When a preset is selected, remove custom from dropdown
    observeEvent(input$preset_select, {
      # "custom" is removed from list when preset is selected
      req(input$preset_select != "custom")

      updateSelectInput(
        inputId = "preset_select",
        choices = names(r$presets),
        selected = input$preset_select
      )
    })

    # When presets are changed (when user save a simulation), then the dropdown is updated.
    observeEvent(r$presets, ignoreInit = TRUE, {
      updateSelectInput(
        inputId = "preset_select",
        choices = names(r$presets),
        selected = r$simulation_name
      )
    })

    # When a setting is imported, select it in preset_select
    observeEvent(r$last_imported_setting, {
      updateSelectInput(
        inputId = "preset_select",
        selected = r$last_imported_setting
      )
    })
  })
}

## To be copied in the UI
# mod_preset_selector_ui("preset_selector_1")

## To be copied in the server
# mod_preset_selector_server("preset_selector_1")
