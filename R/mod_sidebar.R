#' sidebar UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_sidebar_ui <- function(id){
  ns <- NS(id)
  dashboardSidebar(disable = FALSE,
                   width = "30%",
                   collapsed = FALSE,
                   minified = FALSE,
                   fixed = TRUE,

                      )
}

#' sidebar Server Functions
#'
#' @noRd
mod_sidebar_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

  })
}

## To be copied in the UI
#

## To be copied in the server
# mod_sidebar_server("sidebar_1")
