## code to prepare `default` dataset goes here
devtools::load_all(".")

default_model <- load_default_model()

default_parameters_paths <- unname(get_parameters_paths())
default_values <- unname(get_parameters_default_value())

for (organ in get_organs()) {
  default_parameters_paths <- c(default_parameters_paths,
                       glue::glue("Organism|{organ}|Intracellular|Target|Relative expression")
  )

  if (organ != default_parameters()$organ) {
    default_values <- c(default_values, 0)
  } else {
    default_values <- c(default_values, 1)
  }
}

output_paths <- vector(mode = "character", length = length(defaut_output_paths()))

for (i in seq_along(defaut_output_paths())) {
  if (stringr::str_detect(defaut_output_paths()[i], "Organism",negate = TRUE)) {
    output_paths[i] <- glue::glue("Organism|{default_parameters()$organ}|{defaut_output_paths()[i]}")
  } else {
    output_paths[i] <- defaut_output_paths()[i]
  }
}

ospsuite::addOutputs(output_paths, default_model)

simBatch <- ospsuite::createSimulationBatch(default_model,
                                            parametersOrPaths = default_parameters_paths)

simBatch$addRunValues(default_values)

simulation_results <- ospsuite::runSimulationBatches(simBatch)

default_data <- ospsuite::simulationResultsToDataFrame(simulation_results[[1]][[1]])

usethis::use_data(default_data, overwrite = TRUE)
