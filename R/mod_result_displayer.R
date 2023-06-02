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
  tagList(
    bs4Dash::box(title = "Simulation Results",
                 collapsible = FALSE,
                 width = 12,
                 height = "75vh",
                 plotOutput(ns("myplot"),
                            height = "100%"),
                 sidebar = mod_result_sidebar_handler_ui(ns("result_sidebar_handler_1"))
    )
  )
}

#' result_displayer Server Functions
#'
#' @noRd
mod_result_displayer_server <- function(id, r){
  moduleServer( id, function(input, output, session){
    ns <- session$ns

    mod_result_sidebar_handler_server("result_sidebar_handler_1", r)


    observeEvent(r$run_simulation,{
      r$w <- Waitress$new(selector = paste0("#",ns("myplot")),
                          theme = "overlay-percent",
                          infinite = TRUE,
                          hide_on_render = TRUE)
      r$w$start()
    })

    output$myplot <- renderPlot({
      req(r$result_df)
      req(r$plot_settings$output_path_select)
      req(r$plot_settings$yaxis_scale)

      message("Plot simulation results")

      path <- names(output_paths())[output_paths() == r$plot_settings$output_path_select]

      plot <-
        ggplot(r$comparison_df %||% r$result_df,
               aes(x = .data$Time,
                   y = .data[[r$plot_settings$output_path_select]])) +
        labs(x = "Time (s)",
             y = path,
             title = paste0("Simulation of ",
                            path),
             subtitle = paste0("Simulation settings: ",
                               r$simulation_name)
        )

      if (r$compare_sim_toggle && length(r$compared_sim) > 0) {
        plot <- plot +
          geom_line(aes(color = name)) +
          labs(title = paste0("Simulation of ",
                              path),
               subtitle =  paste0("Simulation settings: ",
                                  paste(r$simulation_name,
                                        r$compared_sim,
                                        sep= ", ",
                                        collapse = ", ")),
               color = "Simulation Name")

      } else {
        plot <- plot + geom_line()
      }

      if (r$plot_settings$yaxis_scale == "log") {
        plot <- plot +
          scale_y_log10() +
          labs(y = paste(path, "(log)"))
      }

      on.exit({
        if (!is.null(r$w)) {
          r$w$close()
        }
      })


      return(plot)
    },
    res = 96)


  })
}

## To be copied in the UI
# mod_result_displayer_ui("result_displayer_1")

## To be copied in the server
# mod_result_displayer_server("result_displayer_1")
