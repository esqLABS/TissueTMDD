#' simulation_launcher UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_simulation_launcher_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::actionButton(
    inputId = ns("run_simulation_btn"),
    label = "Run",
    icon = icon("play"),
    width = "100%"
  )
}

#' simulation_launcher Server Functions
#'
#' @noRd
mod_simulation_launcher_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    observeEvent(input$run_simulation_btn, {
      req(r$plot_id)

      start_loading_bar(r, target_id = r$plot_id)

      message("Configuring simulation")

      simulation <- r$model

      # Add Output paths depending on selected Organ
      ospsuite::addOutputs(r$output_paths, simulation)


      parameter_paths <- get_parameters_paths()
      parameter_values <- unlist(unlist(purrr::map(purrr::keep(r$parameters, function(x) "path" %in% names(x)), "value")), use.names = F)

      # Activate selected Organ and disable others
      for (organ in get_organs()) {
        parameter_paths <- c(
          parameter_paths,
          glue::glue("Organism|{organ}|Intracellular|Target|Relative expression")
        )

        if (organ != r$parameters$organ$value) {
          parameter_values <- c(parameter_values, 0)
        } else {
          parameter_values <- c(parameter_values, 1)
        }
      }

      # Change the Simulation time
      ospsuite::setOutputInterval(simulation,
        startTime = 0,
        endTime = r$simulation_time,
        resolution = 1 / 15
      )


      r$simulationBatch <-
        ospsuite::createSimulationBatch(simulation,
          parametersOrPaths = parameter_paths
        )

      r$simulationBatch$addRunValues(parameter_values)

      message("Run simulation")

      r$simulation_results <- ospsuite::runSimulationBatches(r$simulationBatch)
    })
  })
}

## To be copied in the UI
# mod_simulation_launcher_ui("simulation_launcher_1")

## To be copied in the server
# mod_simulation_launcher_server("simulation_launcher_1", r)
