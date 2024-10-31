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
  selectInput(ns("preset_select"),
    label_tooltip("Presets", "Select a preset to load preconfigured settings"),
    multiple = FALSE,
    choices = c("default"),
    width = "50%"
  )
}

#' preset_selector Server Functions
#'
#' @noRd
mod_preset_selector_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    r$presets <- list(
      "default" = purrr::map(default_parameters(), ~ purrr::keep_at(.x, "value"))
    )

    # Update the preset selector when the input list changes
    observeEvent(r$input_list, ignoreInit = TRUE, {
      req(r$input_list)

      preset_found <- FALSE

      # If current settings match a preset, select the preset in
      # the dropdown
      for (preset_name in names(r$presets)) {
        if (isTRUE(all.equal(
          modifyList(r$input_list, r$presets[[preset_name]]),
          r$input_list
        ))) {
          preset_found <- TRUE
          updateSelectInput(
            inputId = "preset_select",
            choices = c(names(r$presets)),
            selected = preset_name
          )
          r$simulation_name <- preset_name
          break
        }
      }

      # otherwise, asign it as custom
      if (!preset_found) {
        updateSelectInput(
          inputId = "preset_select",
          choices = c(names(r$presets), "custom"),
          selected = "custom"
        )
        r$simulation_name <- "custom"
        r$result_df <- NULL
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

      # set simulation name
      r$simulation_name <- input$preset_select

      if (input$preset_select %in% names(r$all_sim_results)) {
        # load stored results
        r$result_df <- r$all_sim_results[[input$preset_select]]
      }
    })


    # When a preset is selected, remove custom from dropdown
    observeEvent(input$preset_select, ignoreInit = TRUE, {
      req(input$preset_select != "custom")

      updateSelectInput(
        inputId = "preset_select",
        choices = names(r$presets),
        selected = input$preset_select
      )
    })

    # When presets are changed (when user save a simulation), then the dropdown is updated.
    observeEvent(r$last_saved_simulation, {
      req(r$last_saved_simulation)

      updateSelectInput(
        inputId = "preset_select",
        choices = names(r$presets),
        selected = r$last_saved_simulation
      )
    })

    # When a setting is imported, select it in preset_select
    observeEvent(r$last_imported_setting, {
      req(r$last_imported_setting)

      updateSelectInput(
        inputId = "preset_select",
        selected = r$last_imported_setting,
        choices = names(r$presets)
      )
    })
  })
}

## To be copied in the UI
# mod_preset_selector_ui("preset_selector_1")

## To be copied in the server
# mod_preset_selector_server("preset_selector_1")
