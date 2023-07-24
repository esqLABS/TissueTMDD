#' plot-colors
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
#'
#'

palette <- function() {
  thematic::okabe_ito(n = 8)
}

main_color <- function(name) {
  return(setNames(c(palette()[3]), name))
}

compared_color <- function(names) {
  available_colors <- palette()[-3]
  n_color <- length(names)
  return(setNames(c(available_colors[1:n_color]), names))
}
