#' result_displayer UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_result_displayer_ui <- function(id){
  ns <- NS(id)
  bs4Dash::box(title = "Results",
               collapsible = FALSE,
               width = 12,
               height = "75vh",
               plotOutput(ns("plot")),
               sidebar = boxSidebar(
                 id = ns("plot-sidebar"),
                 width = 33,
                 h3("Plot Settings"),
                 fluidRow(column(1),
                          selectInput(ns("output_path_select"),
                                      label = "Output Path to Display",
                                      choices = output_paths(),
                                      width = "83%"),
                          column(1))

               ))
}

#' result_displayer Server Functions
#'
#' @noRd
mod_result_displayer_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    output$plot <- renderPlot({
      req(r$result_df)
      req(input$output_path_select)

      message("Plot simulation results")

      if (r$compare_sim_toggle && length(r$compared_sim) > 0) {
        ggplot2::ggplot(r$comparison_df,
                        aes(x = Time,
                            y= .data[[input$output_path_select]],
                            color = name)) +
          geom_line() +
          labs(x = "Time (s)",
               y = names(output_paths()[output_paths() == input$output_path_select]))
      } else {

        ggplot2::ggplot(
          r$result_df,
          aes(x = Time,
              y= .data[[input$output_path_select]])) +
          geom_line() +
          labs(x = "Time (s)",
               y = names(output_paths()[output_paths() == input$output_path_select]))
      }
    },
    res = 96,
    height = 600)


  })
}

## To be copied in the UI
# mod_result_displayer_ui("result_displayer_1")

## To be copied in the server
# mod_result_displayer_server("result_displayer_1")
