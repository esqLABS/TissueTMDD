#' comparison_handler UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_comparison_handler_ui <- function(id){
  ns <- NS(id)
  fluidRow(
    column(5,
           br(),
           checkboxInput(ns("compare_sim_toggle"),
                         label = "Compare with",
                         width = "100%")),
    selectizeInput(ns("compare_sim_select"),
                   label = "",
                   multiple = TRUE,
                   width = "58%",
                   choices = c(NULL),
                   selected = NULL)
  )
}

#' comparison_handler Server Functions
#'
#' @noRd
mod_comparison_handler_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    observeEvent(
      list(r$simulation_name, names(r$all_sim_results)),
      ignoreInit = TRUE, {
        available_sims <- names(r$all_sim_results)
        if (r$simulation_name %in% names(r$all_sim_results)) {
          available_sims <- available_sims[available_sims != r$simulation_name & available_sims != "tmp"]
        }

        updateSelectizeInput(inputId = "compare_sim_select",
                             choices = c(NULL, available_sims),
                             selected = input$compare_sim_select)
      })

    observeEvent(list(input$compare_sim_select, input$compare_sim_toggle, r$result_df), ignoreNULL = FALSE, {

      message("Simulations to compare: ", paste(input$compare_sim_select, collapse = ", "))

      comparison_df <- r$result_df

      for (simulation in input$compare_sim_select) {
        sr <- r$all_sim_results[[simulation]]
        sr$name <- as.character(simulation)
        comparison_df <- bind_rows(comparison_df, sr)
      }
      r$comparison_df <- comparison_df
      r$compared_sim <- input$compare_sim_select
    })

    observeEvent(input$compare_sim_toggle,  {
      r$compare_sim_toggle <- input$compare_sim_toggle

      if (input$compare_sim_toggle == FALSE) {
        updateSelectizeInput(inputId = "compare_sim_select",
                             selected = NULL)
        # r$comparison_df <- NULL
        # r$compared_sim <- NULL
      }
    })

  })
}

## To be copied in the UI
# mod_comparison_handler_ui("comparison_handler_1")

## To be copied in the server
# mod_comparison_handler_server("comparison_handler_1")
