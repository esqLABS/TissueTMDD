## code to prepare `default` dataset goes here
library(TissueTMDD)
library(ospsuite)

default_model <- load_default_model()

default_settings <- init_parameters()

for (p in default_settings) {
  update_model_parameters(default_model,
                          parameter_path = p$path,
                          value = p$value)
}

simulation_results <- ospsuite::runSimulation(default_model)

default_data <- ospsuite::getOutputValues(simulation_results,
                                          quantitiesOrPaths = output_paths()
)$data

usethis::use_data(default_data, overwrite = TRUE)
