#' introduction_provider UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_introduction_provider_ui <- function(id){
  ns <- NS(id)
  bs4Dash::box(title = "Introduction",
               icon = icon("info"),
               width = 12,
               collapsible = TRUE,
               tags$small(
                 shinipsum::random_text(nwords = 50)
               )
  )
}

#' introduction_provider Server Functions
#'
#' @noRd
mod_introduction_provider_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
# mod_introduction_provider_ui("introduction_provider_1")

## To be copied in the server
# mod_introduction_provider_server("introduction_provider_1")
