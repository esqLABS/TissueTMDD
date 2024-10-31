#' The application User-Interface
#'
#' @param request Internal parameter for `{shiny}`.
#'     DO NOT REMOVE.
#' @import shiny
#' @import bs4Dash
#' @import bsicons
#' @noRd
app_ui <- function(request) {
  tagList(
    # Leave this function for adding external resources
    golem_add_external_resources(),
    useShinyjs(),
    useWaitress(),
    # Your application UI logic
    bs4Dash::dashboardPage(
      preloader = list(html = tagList(spin_1(), "Loading TissueTMDD"), color = "#333e48"),
      help = TRUE,
      bs4Dash::dashboardHeader(
        title = "TissueTMDD",
        version_badge()
      ),
      mod_sidebar_ui("sidebar_1"),
      mod_body_ui("body_1"),
      fullscreen = TRUE,
      dark = NULL
    )
  )
}

#' Add external Resources to the Application
#'
#' This function is internally used to add external
#' resources inside the Shiny application.
#'
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function() {
  add_resource_path(
    "www",
    app_sys("app/www")
  )

  tags$head(
    favicon(),
    bundle_resources(
      path = app_sys("app/www"),
      app_title = "TissueTMDD"
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert()
  )
}

version_badge <- function() {
  version <- packageVersion("TissueTMDD")
  # If version ends with .900X, the badge should be orange, otherwise, green
  if (grepl("\\.900[0-9]$", version)) {
    color <- "warning"
  } else {
    color <- "success"
  }

  return(bs4Dash::bs4Badge(paste0("v", version), color = color))
}
