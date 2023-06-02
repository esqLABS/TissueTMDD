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
  bs4Dash::box(title = "Simulation Results",
               collapsible = FALSE,
               width = 12,
               height = "75vh",
               plotOutput(ns("plot")),
               sidebar = mod_result_sidebar_handler_ui(ns("result_sidebar_handler_1"))
  )
}

#' result_displayer Server Functions
#'
#' @noRd
mod_result_displayer_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    mod_result_sidebar_handler_server("result_sidebar_handler_1", r)

    output$plot <- renderPlot({
      req(r$result_df)
      req(r$plot_settings$output_path_select)
      req(r$plot_settings$yaxis_scale)

      message("Plot simulation results")

      path <- names(output_paths())[output_paths() == r$plot_settings$output_path_select]


      plot <-
        ggplot(r$comparison_df,
               aes(x = Time,
                   y= .data[[r$plot_settings$output_path_select]])) +
        labs(x = "Time (s)",
             y = path,
             title = paste0("Simulation of ",
                            path,
                            " (Simulation settings: ",
                            r$simulation_name,
                            " )")
        )

      if (r$compare_sim_toggle && length(r$compared_sim) > 0) {
        plot <- plot +
          geom_line(aes(color = name)) +
          labs(title = paste0("Simulation of ",
                              path,
                              " (Simulation settings: ",
                              paste(r$simulation_name, r$compared_sim, collapse = ", "),
                              " )"))

      } else {
        plot <- plot + geom_line()
      }

      if (r$plot_settings$yaxis_scale == "log") {
        plot <- plot +
          scale_y_log10() +
          labs(y = paste(path, "(log)"))
      }

      return(plot)

    },
    res = 96,
    height = 600)


  })
}

## To be copied in the UI
# mod_result_displayer_ui("result_displayer_1")

## To be copied in the server
# mod_result_displayer_server("result_displayer_1")
