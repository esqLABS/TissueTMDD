#' input_handler UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_input_handler_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::box(
    title = "Simulation Settings",
    width = 12,
    collapsible = FALSE,
    icon = icon("sliders"),
    fluidRow(
      mod_preset_selector_ui(ns("preset_selector_1")),
      mod_settings_importer_ui(ns("settings_importer_1")),
    ),
    tooltip(
      shinyWidgets::sliderTextInput(ns("param_kdeg"),
        "Kdeg [/h]",
        choices = c(0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10),
        selected = 0.001,
        grid = T
      ),
      title = "Target degradation constant",
      placement = "top"
    ),
    tooltip(
      shinyWidgets::sliderTextInput(ns("param_kd"),
        "Kd, [nM]",
        choices = c(0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100),
        selected = 0.001,
        grid = T
      ),
      title = "Equilibrium dissociation constant",
      placement = "top"
    ),
    tooltip(
      shinyWidgets::sliderTextInput(ns("param_koff"),
        "Koff, [/h]",
        choices = c(0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100),
        selected = 1,
        grid = T
      ),
      title = "Drug-Target Dissociation constant",
      placement = "top"
    ),
    tooltip(
      shinyWidgets::sliderTextInput(ns("param_target_c"),
        "Target Concentration, [nM]",
        choices = c(0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100),
        selected = 1,
        grid = T
      ),
      title = "Target Concentration",
      placement = "top"
    ),
    tooltip(
      numericInput(ns("param_dose"),
        "Dose, [mg/kg]",
        value = 10,
        min = 0,
        step = 1
      ),
      title = "Drug dose",
      placement = "top"
    )
  )
}

#' input_handler Server Functions
#'
#' @noRd
mod_input_handler_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    mod_preset_selector_server("preset_selector_1", r)
    mod_settings_importer_server("settings_importer_1", r)

    r$parameters <- init_parameters()

    # When any input changes, updates parameters value
    observe({
      r$parameters$kdeg$value <- as.numeric(input$param_kdeg)
      r$parameters$kd$value <- as.numeric(input$param_kd)
      r$parameters$koff$value <- as.numeric(input$param_koff)
      r$parameters$target_c$value <- as.numeric(input$param_target_c)
      r$parameters$dose$value <- as.numeric(input$param_dose)
    })


    # when parameters are changed, update model parameters
    observeEvent(r$parameters, ignoreInit = TRUE, {
      for (p in r$parameters) {
        update_model_parameters(r$model,
          parameter_path = p$path,
          value = p$value
        )
      }
    })


    # When preset is selected, update inputs
    observeEvent(r$preset, ignoreInit = TRUE, {
      purrr::imap(r$preset, ~ update_input(parameter_name = .y, value = .x$value, session = session))
    })
  })
}

## To be copied in the UI
# mod_input_handler_ui("input_handler_1")

## To be copied in the server
# mod_input_handler_server("input_handler_1")


init_parameters <- function() {
  return(
    list(
      kdeg = list(
        type = "slider",
        value = 0.001,
        path = "Target degradation|kdeg"
      ),
      kd = list(
        type = "slider",
        value = 0.001,
        path = "Large Molecule Drug-Target-default|Kd"
      ),
      koff = list(
        type = "slider",
        value = 1,
        path = "Large Molecule Drug-Target-default|koff"
      ),
      target_c = list(
        type = "slider",
        value = 1,
        path = "Target|Reference concentration"
      ),
      dose = list(
        type = "numeric",
        value = 10,
        path = "Applications|single IV|Application_1|ProtocolSchemaItem|DosePerBodyWeight"
      )
    )
  )
}

update_model_parameters <- function(model, parameter_path, value) {
  current <- ospsuite::getParameter(path = parameter_path, container = model)

  if (current$value != value) {
    ospsuite::setParameterValues(parameters = current, values = value)
  }
}

update_input <- function(parameter_name, value, session) {
  inputId <- paste0("param_", parameter_name)
  switch(init_parameters()[[parameter_name]]$type,
    "slider" = shinyWidgets::updateSliderTextInput(
      session = session,
      inputId = inputId,
      selected = value
    ),
    "numeric" = updateNumericInput(
      inputId = inputId,
      value = value
    )
  )
}
