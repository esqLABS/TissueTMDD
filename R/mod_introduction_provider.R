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
    withMathJax(),
    helpText(
      tags$b(
        HTML(
          "This <a href='https://github.com/esqLABS/TissueTMDD/blob/main/inst/extdata/Large%20molecule%20Human%20default.pkml'>model</a>
      is based on the PK-Sim model for large molecules in humans and
      is extended in Mobi with target binding to a target expressed in the
      interstitial space of an organ."
        )
      ),
      HTML("<br>
      The target is degraded with a first-order rate constant \\(k_{deg}\\)
      and synthesized with a zero-order rate constant \\(k_{syn}\\)
      which is calculated as the product of the target concentration in the
      interstitial space and the \\(k_{deg}\\).
      <br>
      The drug-target complex is degraded with a first-order rate constant \\(k_{int}\\).
      <br>
      Various outputs can be selected in the plot options.
      <br>
      Disclaimer: no rights can be derived from this model or any of its output.")
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
