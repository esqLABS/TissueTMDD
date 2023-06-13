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

               tooltip(
                 sliderInput(ns("param_kdeg"),
                             "Target Degradation (Kdeg, [1/min])",
                             min = 0,
                             max = 0.01,
                             value = 0.0017,
                             step = 0.0001),
                 title = "Target degradation constant",
                 placement = "top"),
               tooltip(
                 sliderInput(ns("param_kd"),
                             "Kd, [\u00B5mol/l]",
                             min = 0,
                             max = 0.01,
                             value = 0.001,
                             step = 0.001
                 ),
                 title = "Equilibrium dissociation constant",
                 placement = "top"),
               tooltip(
                 sliderInput(ns("param_koff"),
                             "Koff, [1/min]",
                             min = 0,
                             max = 10,
                             value = 1L,
                             step = 1
                 ),
                 title = "Drug-Target Dissociation constant",
                 placement = "top"),
               tooltip(
                 numericInput(ns("param_target_c"),
                              "Target Concentration, [\u00B5mol/l]",
                              value = 0.1,
                              min = 0,
                              step = 0.1),
                 title = "Target Concentration",
                 placement = "top"),
               tooltip(
               numericInput(ns("param_dose"),
                            "Dose, [kg/kg]",
                            value = 5e-6,
                            min = 0,
                            step = 0.001),
               title = "Drug dose",
               placement = "top")
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

    r$parameters <- init_parameters()

    # When any input changes, updates parameters value
    observe({
      r$parameters$kdeg$value <- input$param_kdeg
      r$parameters$kd$value <- input$param_kd
      r$parameters$koff$value <- input$param_koff
      r$parameters$target_c$value <- input$param_target_c
      r$parameters$dose$value <- input$param_dose
    })


    # when parameters are changed, update model parameters
    observeEvent(r$parameters, ignoreInit = TRUE, {
      for (p in r$parameters) {
        update_model_parameters(r$model,
                                parameter_path = p$path,
                                value = p$value)
      }
    })


    # When preset is selected, update inputs
    observeEvent(r$preset, ignoreInit = TRUE, {
      purrr::imap(r$preset, ~update_input(parameter_name = .y, value = .x$value))
    })


  })
}

## To be copied in the UI
# mod_input_handler_ui("input_handler_1")

## To be copied in the server
# mod_input_handler_server("input_handler_1")


init_parameters <- function(){
  return(
    list(kdeg = list(type = "slider",
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
  )

}

update_model_parameters <- function(model, parameter_path, value){
  current <- ospsuite::getParameter(path = parameter_path, container = model)

  if (current$value != value) {
    ospsuite::setParameterValues(parameters = current, values = value)
  }
}

update_input <- function(parameter_name, value) {
  inputId <-  paste0("param_", parameter_name)
  switch (init_parameters()[[parameter_name]]$type,
          "slider" = updateSliderInput(inputId = inputId ,
                                       value = value),
          "numeric" = updateNumericInput(inputId = inputId,
                                         value = value)
  )
}


