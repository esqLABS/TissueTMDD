#' toast
#'
#' @description A utils function
#'
#' @return The return value, if any, from executing the utility.
#'
#' @noRd
generate_toast <- function(title = "title",
                           body = "text",
                           icon = "fas fa-apple",
                           status = "sucess") {
  toast(
    title = title,
    body = body,
    options = list(
      autohide = TRUE,
      icon = "fas fa-download",
      close = FALSE,
      delay = 2000,
      class = paste0("bg-", status),
      position = "bottomRight"
    )
  )
}
