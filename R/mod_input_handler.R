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
                                    choices = sort(c(0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10)),
                                    selected = get_parameters_default_value()["kdeg"],
                                    grid = T
      ),
      title = "Target degradation constant",
      placement = "top"
    ),
    tooltip(
      shinyWidgets::sliderTextInput(ns("param_kd"),
                                    "Kd, [nM]",
                                    choices = sort(c(0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100)),
                                    selected = get_parameters_default_value()["kd"],
                                    grid = T
      ),
      title = "Equilibrium dissociation constant",
      placement = "top"
    ),
    tooltip(
      shinyWidgets::sliderTextInput(ns("param_koff"),
                                    "Koff, [/h]",
                                    choices = sort(c(0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100)),
                                    selected = get_parameters_default_value()["koff"],
                                    grid = T
      ),
      title = "Drug-Target Dissociation constant",
      placement = "top"
    ),
    tooltip(
      shinyWidgets::sliderTextInput(ns("param_kint"),
                                    "Kint",
                                    choices = sort(c(0.001, 0.003, 0.01, 0.03, 0.1, 0.3, 1, 3, 10)),
                                    selected = get_parameters_default_value()["kint"],
                                    grid = T
      ),
      title = "Complex Internalization Rate Constant",
      placement = "top"
    ),
    tooltip(
      shinyWidgets::sliderTextInput(ns("param_target_c"),
                                    "Target Concentration, [nM]",
                                    choices = sort(c(0.01, 0.03, 0.1, 0.3, 1, 3, 10, 30, 100)),
                                    selected = get_parameters_default_value()["target_c"],
                                    grid = T
      ),
      title = "Target Concentration",
      placement = "top"
    ),
    tooltip(
      selectInput(ns("organ"),
                  "Target Expression Tissue",
                  choices = get_organs(),
                  multiple = FALSE,
                  selected = get_parameters_default_value()["organ"],
                  width = "100%"
      ),
      title = "Target Expression Tissue",
      placement = "top"
    ),
    tooltip(
      numericInput(ns("param_mol_w_kda"),
                   "Molecular Weight [kDa]",
                   value = get_parameters_default_value()["mol_w_kda"],
                   min = 1,
                   width = "100%"
      ),
      title = "Molecular Weight of Drug",
      placement = "top"
    ),
    tooltip(
      textInput(ns("param_dose"),
                "Dose, [mg/kg]",
                value = get_parameters_default_value()["dose_1"],
                width = "100%"
      ),
      title = "Drug dose",
      placement = "top"
    ),
    tooltip(
      selectInput(ns("param_dose_frequency"),
                  label = "Dose Frequency",
                  choices = list("Single Dose" = 0,
                                 "Once a Day" = 1,
                                 "Once a Week" = 7,
                                 "Once every two weeks" = 14),
                  selected = get_parameters_default_value()["dose_frequency"],
                  width = "100%"
      ),
      title = "Chose interval between doses",
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


    observe({
      parameters <- default_parameters()
      parameters$kdeg$value <- as.numeric(input$param_kdeg)
      parameters$kd$value <- as.numeric(input$param_kd)
      parameters$koff$value <- as.numeric(input$param_koff)
      parameters$target_c$value <- as.numeric(input$param_target_c)
      parameters$kint$value <- as.numeric(input$param_kint)
      parameters$kint_kdeg_ratio$value <- parameters$kint$value / parameters$kdeg$value
      parameters$mol_w$value <- as.numeric(input$param_mol_w_kda)
      parameters$dose_1$value <- as.numeric(input$param_dose)
      parameters$dose_frequency$value <- as.numeric(input$param_dose_frequency)

      r$input_list <- parameters

    })

    # When any input changes, updates parameters value
    observeEvent(r$input_list, {

      r$parameters <- convert_parameters_unit(r$input_list)

      if (input$param_dose_frequency == 0) {
        r$parameters$dose_2$value <- 0
        r$parameters$dose_3$value <- 0
        r$parameters$dose_4$value <- 0
        r$parameters$dose_5$value <- 0
        r$parameters$dose_6$value <- 0
        r$parameters$dose_7$value <- 0

        r$simulation_time <- lubridate::ddays(1) / lubridate::dminutes(1) # simulation of 1 day
      } else {
        r$parameters$dose_2$value <- r$parameters$dose_1$value
        r$parameters$dose_3$value <- r$parameters$dose_1$value
        r$parameters$dose_4$value <- r$parameters$dose_1$value
        r$parameters$dose_5$value <- r$parameters$dose_1$value
        r$parameters$dose_6$value <- r$parameters$dose_1$value
        r$parameters$dose_7$value <- r$parameters$dose_1$value

        r$simulation_time <- 8 * r$parameters$dose_frequency$value * lubridate::ddays(1) / lubridate::dminutes(1)
      }

      for (i in 1:7) {
        r$parameters[[paste("starttime",i, sep='_')]]$value <- (i-1) * r$parameters$dose_frequency$value * lubridate::ddays(1) / lubridate::dminutes(1)
      }

      r$parameters$organ$value <- input$organ

    })

    # Add outputs corresponding to the selected organ
    observeEvent(r$parameters$organ$value, {
      output_paths <- vector(mode = "character", length = length(defaut_output_paths()))

      for (i in seq_along(defaut_output_paths())) {
        if (stringr::str_detect(defaut_output_paths()[i], "Organism", negate = TRUE)) {
          output_paths[i] <- glue::glue("Organism|{r$parameters$organ$value}|{defaut_output_paths()[i]}")
        } else {
          output_paths[i] <- defaut_output_paths()[i]
        }
      }

      # return paths to r$ so it is updated in result_sidebar_handler module
      names(output_paths) <- names(defaut_output_paths())
      r$output_paths <- output_paths
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

default_parameters <- function() {
  return(
    list(
      kdeg = list(
        type = "slider",
        value = 0.01,
        path = "Target Degradation|kdeg"
      ),
      kd = list(
        type = "slider",
        value = 0.001,
        path = "mAb-Target-Test1|Kd"
      ),
      koff = list(
        type = "slider",
        value = 0.1,
        path = "mAb-Target-Test1|koff"
      ),
      target_c = list(
        type = "slider",
        value = 0.1,
        path = "Target|Reference concentration"
      ),
      kint = list(
        type = "slider",
        value = 0.01
      ),
      kint_kdeg_ratio = list(
        type = "slider",
        value = 1,
        path = "Complex Internalization|kint_kdeg_ratio"
      ),
      mol_w = list(
        type = "numeric",
        value = 150,
        path = "mAb|Molecular weight"
      ),
      mol_w_kda = list(
        type = "numeric",
        value = 150
      ),
      dose_1 = list(
        type = "numeric",
        value = 1,
        path = "Applications|3 months, 1 mg/kg|Application_1|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_2 = list(
        type = "numeric",
        value = 1,
        path = "Applications|3 months, 1 mg/kg|Application_2|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_3 = list(
        type = "numeric",
        value = 1,
        path = "Applications|3 months, 1 mg/kg|Application_3|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_4 = list(
        type = "numeric",
        value = 1,
        path = "Applications|3 months, 1 mg/kg|Application_4|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_5 = list(
        type = "numeric",
        value = 1,
        path = "Applications|3 months, 1 mg/kg|Application_5|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_6 = list(
        type = "numeric",
        value = 1,
        path = "Applications|3 months, 1 mg/kg|Application_6|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_7 = list(
        type = "numeric",
        value = 1,
        path = "Applications|3 months, 1 mg/kg|Application_7|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_frequency = list(
        type = "select",
        value = 1
      ),
      starttime_1 = list(
        type = "numeric",
        value = 0,
        path = "Applications|3 months, 1 mg/kg|Application_1|ProtocolSchemaItem|Start time"
      ),
      starttime_2 = list(
        type = "numeric",
        value = 1 * lubridate::ddays(1) / lubridate::dminutes(1),
        path = "Applications|3 months, 1 mg/kg|Application_2|ProtocolSchemaItem|Start time"
      ),
      starttime_3 = list(
        type = "numeric",
        value = 2 * lubridate::ddays(1) / lubridate::dminutes(1),
        path = "Applications|3 months, 1 mg/kg|Application_3|ProtocolSchemaItem|Start time"
      ),
      starttime_4 = list(
        type = "numeric",
        value = 3 * lubridate::ddays(1) / lubridate::dminutes(1),
        path = "Applications|3 months, 1 mg/kg|Application_4|ProtocolSchemaItem|Start time"
      ),
      starttime_5 = list(
        type = "numeric",
        value = 4 * lubridate::ddays(1) / lubridate::dminutes(1),
        path = "Applications|3 months, 1 mg/kg|Application_5|ProtocolSchemaItem|Start time"
      ),
      starttime_6 = list(
        type = "numeric",
        value = 5 * lubridate::ddays(1) / lubridate::dminutes(1),
        path = "Applications|3 months, 1 mg/kg|Application_6|ProtocolSchemaItem|Start time"
      ),
      starttime_7 = list(
        type = "numeric",
        value = 6 * lubridate::ddays(1) / lubridate::dminutes(1),
        path = "Applications|3 months, 1 mg/kg|Application_7|ProtocolSchemaItem|Start time"
      ),
      organ = list(
        type = "select",
        value = "Heart"
      )
    )
  )
}

get_parameters_id <- function() {
  names(default_parameters())
}

get_parameters_paths <- function() {
  unlist(purrr::map(default_parameters(), "path"))
}


get_parameters_default_value <- function() {
  unlist(purrr::map(default_parameters(), "value"))
}


get_parameters_type <- function() {
  unlist(purrr::map(default_parameters(), "type"))
}

get_organs <- function() {
  c(
    "Heart",
    "Bone",
    "Brain",
    "Muscle",
    "Skin",
    "Liver|Periportal",
    "Lung",
    "Kidney",
    "Fat",
    "Spleen"
  )
}


update_input <- function(parameter_name, value, session) {
  inputId <- paste0("param_", parameter_name)
  switch(default_parameters()[[parameter_name]]$type,
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

defaut_output_paths <- function() {
  c(
    "Drug Plasma concentration" = "Organism|PeripheralVenousBlood|mAb|Plasma (Peripheral Venous Blood)",
    "Drug interstitial concentration" = "Interstitial|mAb|Concentration in container",
    "Target interstitial concentration (unbound)" = "Interstitial|Target|Concentration in container",
    "Target interstitial concentration (total)" = "Interstitial|Target|Total target concentration",
    "Target occupancy" = "Interstitial|mAb-Target-Test1 Complex|Receptor Occupancy-mAb-Target-Test1 Complex"
  )
}

convert_parameters_unit <- function(parameters){
  # cf. https://github.com/esqLABS/TissueTMDD/issues/36
  parameters$kdeg$value <- parameters$kdeg$value / 60 # transform from 1/h to 1/min
  parameters$kd$value <-  parameters$kd$value / 1000 # transform from nM to µmol/l
  parameters$koff$value <- parameters$koff$value / 60 # transform from 1/h to 1/min
  parameters$target_c$value <-parameters$target_c$value / 1000 # transform from to nM to µmol/l
  parameters$mol_w$value <- parameters$mol_w$value * 1e-6 # transform from KDa to kg/µmol
  parameters$dose_1$value <- parameters$dose_1$value * 1e-6 # transform from 	mg/kg to kg/kg

  return(parameters)
}
