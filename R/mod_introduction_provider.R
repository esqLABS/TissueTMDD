#' introduction_provider UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_introduction_provider_ui <- function(id) {
  ns <- NS(id)
  bs4Dash::box(
    title = "Introduction",
    icon = icon("info"),
    width = 12,
    collapsible = TRUE,
    tags$small(
      "This model is based on the PK-Sim model for large molecules in humans and
      is extended in Mobi with target binding to a target expressed in the
      interstitial space of an organ. The target is degraded with a first-order
      rate constant kdeg and synthesized with a zero-order rate constant ksyn,
      which is calculated as the product of the target concentration in the
      interstitial space and the kdeg. The drug-target complex is degraded with
      a first-order rate constant kint. Various outputs can be selected in the
      plot options.",
      br(),
      "Disclaimer: no rights can be derived from this model or any of its output"
    )
  )
}

#' introduction_provider Server Functions
#'
#' @noRd
mod_introduction_provider_server <- function(id) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns
  })
}

## To be copied in the UI
# mod_introduction_provider_ui("introduction_provider_1")

## To be copied in the server
# mod_introduction_provider_server("introduction_provider_1")
