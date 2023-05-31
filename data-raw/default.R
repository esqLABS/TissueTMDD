## code to prepare `default` dataset goes here
library(TissueTMDD)
library(ospsuite)

default_model <- load_default_model()

simulation_results <- ospsuite::runSimulation(default_model)

default_data <- ospsuite::getOutputValues(simulation_results,
                          quantitiesOrPaths = output_paths()
)$data

usethis::use_data(default_data, overwrite = TRUE)
