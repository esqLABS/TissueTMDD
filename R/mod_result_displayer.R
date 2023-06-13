#' result_displayer UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd
#'
#' @importFrom shiny NS tagList
mod_result_displayer_ui <- function(id) {
  ns <- NS(id)
  uiOutput(ns("result_area"))
}

#' result_displayer Server Functions
#'
#' @noRd
mod_result_displayer_server <- function(id, r) {
  moduleServer(id, function(input, output, session) {
    ns <- session$ns

    mod_result_sidebar_handler_server("result_sidebar_handler_1", r)

    r$plot_id <- paste0("#", ns("result_area"))

    output$result_area <- renderUI({
      result_df_isnull <- is.null(r$result_df)

      if (result_df_isnull) {
        bs4Dash::box(
          title = "",
          headerBorder = FALSE,
          collapsible = FALSE,
          width = 12,
          height = "80vh",
          column(
            width = 6,
            offset = 3,
            bs4Dash::callout("Please, run the simulation",
              title = "No data",
              status = "danger",
              width = 12
            ),
            style = "margin-top: 30vh;"
          )
        )
      } else {
        bs4Dash::box(
          title = "Simulation Results",
          collapsible = FALSE,
          width = 12,
          height = "80vh",
          plotOutput(ns("plot"), height = "100%"),
          sidebar = mod_result_sidebar_handler_ui(ns("result_sidebar_handler_1"),
            plot_sidebar_state = r$plot_sidebar_state,
            selected_output_path = r$plot_settings$selected_output_path,
            selected_y_scale = r$plot_settings$selected_y_scale,
            selected_time_range = r$plot_settings$selected_time_range
          )
        )
      }
    })

    output$plot <- renderPlot(
      {
        req(r$result_df)

        message("Plot simulation results")

        path <- names(output_paths())[output_paths() == r$plot_settings$selected_output_path]

        if (r$compare_sim_toggle) {
          plot <-
            ggplot(
              r$comparison_df,
              aes(
                x = .data$Time,
                y = .data[[r$plot_settings$selected_output_path]]
              )
            ) +
            scale_color_manual(values = r$palette)
        } else {
          plot <-
            ggplot(
              r$result_df,
              aes(
                x = .data$Time,
                y = .data[[r$plot_settings$selected_output_path]]
              )
            ) +
            scale_color_manual(values = main_color(unique(r$result_df$name)))
        }

        plot <- plot +
          coord_cartesian(xlim = r$plot_settings$selected_time_range) +
          labs(
            x = "Time (s)",
            y = path,
            title = paste0(
              "Simulation of ",
              path
            ),
            subtitle = paste0(
              "Simulation settings: ",
              r$simulation_name
            )
          )

        if (r$compare_sim_toggle && length(r$compared_sim) > 0) {
          plot <- plot +
            geom_line(aes(color = name)) +
            labs(
              title = paste0(
                "Simulation of ",
                path
              ),
              subtitle = paste0(
                "Simulation settings: ",
                paste(r$simulation_name,
                  r$compared_sim,
                  sep = ", ",
                  collapse = ", "
                )
              ),
              color = "Simulation Name"
            )
        } else {
          plot <- plot + geom_line(aes(color = name),
                                   show.legend = FALSE)
        }

        if (r$plot_settings$selected_y_scale == "log") {
          plot <- plot +
            scale_y_log10() +
            labs(y = paste(path, "(log)"))
        }

        on.exit(stop_loading_bar(r, target_id = r$plot_id))


        return(plot)
      },
      res = 96
    )
  })
}

## To be copied in the UI
# mod_result_displayer_ui("result_displayer_1")

## To be copied in the server
# mod_result_displayer_server("result_displayer_1")
