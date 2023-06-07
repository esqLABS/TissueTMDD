#' start a loading bar
#'
#' @param r the reactive values object
#' @param target_id the html selector of the object where to display the loading
#' bar
#'
#' @noRd
start_loading_bar <- function(r, target_id) {
  loading_bar_id <- paste("loading_bar", target_id, sep = "_")
  r[[loading_bar_id]] <- Waitress$new(selector = target_id,
                                      theme = "overlay-percent",
                                      infinite = TRUE,
                                      hide_on_render = TRUE)

  r[[loading_bar_id]]$start()
}

#' start a loading bar
#'
#' @param r the reactive values object
#' @param target_id the html selector of the object where to display the loading
#' bar
#'
#' @examples
stop_loading_bar <- function(r, target_id){
  loading_bar_id <- paste("loading_bar", target_id, sep = "_")
  if (!is.null(r[[loading_bar_id]])) {
    r[[loading_bar_id]]$close()
  }
}
