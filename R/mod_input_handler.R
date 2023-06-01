#' input_handler UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_input_handler_ui <- function(id){
  ns <- NS(id)
  bs4Dash::box(title = "Simulation Settings",
               width = 12,
               collapsible = FALSE,
               fluidRow(
                 mod_preset_selector_ui(ns("preset_selector_1")),
                 mod_settings_importer_ui(ns("settings_importer_1")),
               ),
               sliderInput(ns("param_kdeg"),
                           "Target Degradation (Kdeg, [1/min])",
                           min = 0,
                           max = 0.01,
                           value = 0.0017,
                           step = 0.0001
               ),
               sliderInput(ns("param_kd"),
                           "Kd, [µmol/l]",
                           min = 0,
                           max = 0.01,
                           value = 0.001,
                           step = 0.001
               ),

               sliderInput(ns("param_koff"),
                           "Koff, [1/min]",
                           min = 0,
                           max = 10,
                           value = 1L,
                           step = 1
               ),
               numericInput(ns("param_target_c"),
                            "Target Concentration, [µmol/l]",
                            value = 0.1,
                            min = 0,
                            step = 0.1),
               numericInput(ns("param_dose"),
                            "Dose, [kg/kg]",
                            value = 5e-6,
                            min = 0,
                            step = 0.001)
  )
}

#' input_handler Server Functions
#'
#' @noRd
mod_input_handler_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    mod_preset_selector_server("preset_selector_1", r)
    mod_settings_importer_server("settings_importer_1", r)

    r$parameters <- list(kdeg = list(type = "slider",
                                     value = 0.0017,
                                     path = "Target degradation|kdeg"),
                         kd = list(type = "slider",
                                   value = 0.001,
                                   path = "Large Molecule Drug-Target-default|Kd"),
                         koff = list(type = "slider",
                                     value = 1,
                                     path = "Large Molecule Drug-Target-default|koff"),
                         target_c = list(type = "numeric",
                                         value = 0.1,
                                         path = "Target|Reference concentration"),
                         dose = list(type = "numeric",
                                     value = 5e-6,
                                     path = "Applications|single IV|Application_1|ProtocolSchemaItem|DosePerBodyWeight"))

    # When any input changes, updates parameters value
    observe({
      r$parameters$kdeg$value <- input$param_kdeg
      r$parameters$kd$value <- input$param_kd
      r$parameters$koff$value <- input$param_koff
      r$parameters$target_c$value <- input$param_target_c
      r$parameters$dose$value <- input$param_dose
    })

    # When preset is selected, update inputs
    observeEvent(r$preset, ignoreInit = TRUE, {
      # r$parameters <- modifyList(r$parameters, r$preset)
      for (parameter in names(r$preset)) {
        inputId <-  paste0("param_", parameter)
        value <- r$preset[[parameter]]$value
        switch (r$parameters[[parameter]]$type,
                "slider" = updateSliderInput(inputId = inputId ,
                                             value = value),
                "numeric" = updateNumericInput(inputId = inputId,
                                               value = value)
        )
      }
    })

    # when parameters are changed, update model
    observeEvent(r$parameters, ignoreInit = TRUE, {
      for (p in r$parameters) {
        update_parameter(r$model,
                         parameter_path = p$path,
                         value = p$value)
      }
    })

  })
}

## To be copied in the UI
# mod_input_handler_ui("input_handler_1")

## To be copied in the server
# mod_input_handler_server("input_handler_1")


update_parameter <- function(model, parameter_path, value){
  current <- ospsuite::getParameter(path = parameter_path, container = model)

  if (current$value != value) {
    ospsuite::setParameterValues(parameters = current, values = value)
  }
}


