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
      title = "Complex Internalization Rate Complex",
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
        selected = get_parameters_default_value()["organ"]
      ),
      title = "Target Expression Tissue",
      placement = "top"
    ),
    fluidRow(
      column(
        6,
        tooltip(
          textInput(ns("param_mol_w"),
            "Molecular Weight",
            value = get_parameters_default_value()["mol_w"],
          ),
          title = "Molecular Weight Drug",
          placement = "top"
        )
      ),
      column(
        6,
        tooltip(
          textInput(ns("param_mol_radius"),
            "Hydrodynamic Radius",
            value = get_parameters_default_value()["mol_radius"],
          ),
          title = "Drug Hydrodynamic Radius",
          placement = "top"
        )
      )
    ),
    fluidRow(
      column(
        8,
        tooltip(
          textInput(ns("param_dose"),
            "Dose, [mg/kg]",
            value = get_parameters_default_value()["dose_1"],
          ),
          title = "Drug dose",
          placement = "top"
        )
      ),
      column(
        width = 4,
        br(),
        br(),
        tooltip(
          checkboxInput(ns("param_repeat_dose"),
            label = "Repeat Dose",
            value = as.logical(get_parameters_default_value()["repeat_dose"]),
            width = "100%"
          ),
          title = "Check this box for repeated dose over time",
          placement = "top"
        )
      )
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

    r$parameters <- default_parameters()

    # When any input changes, updates parameters value
    observe({
      r$parameters$kdeg$value <- as.numeric(input$param_kdeg)
      r$parameters$kd$value <- as.numeric(input$param_kd)
      r$parameters$koff$value <- as.numeric(input$param_koff)
      r$parameters$target_c$value <- as.numeric(input$param_target_c)
      r$parameters$kint$value <- as.numeric(input$param_kint)

      r$parameters$kint_kdeg_ratio$value <- r$parameters$kint$value / r$parameters$kdeg$value

      r$parameters$mol_w$value <- as.numeric(input$param_mol_w)
      r$parameters$mol_radius$value <- as.numeric(input$param_mol_radius)

      r$parameters$repeat_dose$value <- as.logical(input$param_repeat_dose)
      r$parameters$dose_1$value <- as.numeric(input$param_dose)

      if (input$param_repeat_dose) {
        r$parameters$dose_2$value <- as.numeric(input$param_dose)
        r$parameters$dose_3$value <- as.numeric(input$param_dose)
        r$parameters$dose_4$value <- as.numeric(input$param_dose)
        r$parameters$dose_5$value <- as.numeric(input$param_dose)
        r$parameters$dose_6$value <- as.numeric(input$param_dose)
        r$parameters$dose_7$value <- as.numeric(input$param_dose)
      } else {
        r$parameters$dose_2$value <- 0
        r$parameters$dose_3$value <- 0
        r$parameters$dose_4$value <- 0
        r$parameters$dose_5$value <- 0
        r$parameters$dose_6$value <- 0
        r$parameters$dose_7$value <- 0
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
        value = 0.00015,
        path = "mAb|Molecular weight"
      ),
      mol_radius = list(
        type = "numeric",
        value = 5.126966e-08,
        path = "mAb|Radius (solute)"
      ),
      dose_1 = list(
        type = "numeric",
        value = 1e-06,
        path = "Applications|3 months, 1 mg/kg|Application_1|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_2 = list(
        type = "numeric",
        value = 1e-06,
        path = "Applications|3 months, 1 mg/kg|Application_2|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_3 = list(
        type = "numeric",
        value = 1e-06,
        path = "Applications|3 months, 1 mg/kg|Application_3|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_4 = list(
        type = "numeric",
        value = 1e-06,
        path = "Applications|3 months, 1 mg/kg|Application_4|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_5 = list(
        type = "numeric",
        value = 1e-06,
        path = "Applications|3 months, 1 mg/kg|Application_5|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_6 = list(
        type = "numeric",
        value = 1e-06,
        path = "Applications|3 months, 1 mg/kg|Application_6|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      dose_7 = list(
        type = "numeric",
        value = 1e-06,
        path = "Applications|3 months, 1 mg/kg|Application_7|ProtocolSchemaItem|DosePerBodyWeight"
      ),
      repeat_dose = list(
        type = "logical",
        value = TRUE
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

get_parameters_path_default_values <- function() {
  unlist(purrr::map(purrr::keep(default_parameters(), function(x) "path" %in% names(x)), "value"))
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
