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
      if (is.null(r$comparison_df)) {
        no_results_box
      } else {
        result_box()
      }
    })

    no_results_box <-
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

    result_box <- reactive({
      req(r$comparison_df)

      bs4Dash::box(
        title = "Simulation Results",
        collapsible = FALSE,
        width = 12,
        height = "80vh",
        plotOutput(ns("plot"), height = "100%"),
        sidebar = mod_result_sidebar_handler_ui(ns("result_sidebar_handler_1"),
          plot_sidebar_state = r$plot_sidebar_state,
          choices_output_path = r$output_paths,
          selected_output_path = r$plot_settings$selected_output_path,
          selected_y_scale = r$plot_settings$selected_y_scale,
          selected_time_unit = r$plot_settings$selected_time_unit,
          selected_time_range = r$plot_settings$selected_time_range,
          time_range_limits = r$plot_settings$time_range_limits
        )
      )
    })

    observe({

      req(r$comparison_df)

      time_unit_duration <-
        if (r$plot_settings$selected_time_unit == "Days") {
          lubridate::ddays(1)
        } else if (r$plot_settings$selected_time_unit == "Hours") {
          lubridate::dhours(1)
        }

      r$result_df_time_transformed <-
        dplyr::mutate(r$comparison_df,
                      Time = lubridate::duration(Time, units = unique(r$comparison_df$TimeUnit)) / time_unit_duration
      )

      r$plot_settings$time_range_limits <- c(min(r$result_df_time_transformed$Time), ceiling(max(r$result_df_time_transformed$Time)))

      r$plot_settings$selected_time_range <- r$plot_settings$time_range_limits
    })

    output$plot <- renderPlot(
      {
        req(r$result_df_time_transformed)

        message(glue::glue("Plot simulation results for {r$plot_settings$selected_output_path}"))

        plot_df <- r$result_df_time_transformed

        plot_df <- dplyr::filter(
          plot_df,
          paths == r$plot_settings$selected_output_path
        )

        path <- names(r$output_paths)[r$output_paths == r$plot_settings$selected_output_path]

        unit <- plot_df %>%
          distinct(dimension, unit) %>%
          mutate(unit = case_when(
            unit == "" ~ dimension,
            TRUE ~ unit
          )) %>%
          pull(unit)


        plot_df <- plot_df %>%
          dplyr::filter(Time >= r$plot_settings$selected_time_range[1] & Time <= r$plot_settings$selected_time_range[2])



        plot <-
          ggplot(
            plot_df,
            aes(
              x = .data$Time,
              y = simulationValues
            )
          )

        if (r$compare_sim_toggle) {
          plot <- plot +
            scale_color_manual(values = r$palette)
        } else {
          plot <- plot +
            scale_color_manual(values = main_color(unique(r$plot_data$name)))
        }

        plot <- plot +
          labs(
            x = glue::glue("Time [{r$plot_settings$selected_time_unit}]"),
            y = glue::glue("{path} [{unit}]"),
            title = glue::glue("Simulation of {path} ({r$parameters$organ$value})")
          )

        if (r$compare_sim_toggle && length(r$compared_sim) > 0) {
          plot <- plot +
            geom_line(aes(color = name)) +
            labs(
              title = path,
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
            show.legend = FALSE
          )
        }

        if (r$plot_settings$selected_y_scale == "log") {
          plot <- plot +
            scale_y_log10()
        }

        plot <- plot +
          ggthemes::theme_economist() +
          theme(
            panel.background = element_blank(),
            plot.background = element_blank(),
            panel.grid.major.y = element_line(colour = "grey40", linewidth = 0.2),
            axis.text.y = element_text(hjust = 1),
            axis.title.y = element_text(margin = margin(t = 0, r = 15, b = 0, l = 0)),
            axis.title.x = element_text(margin = margin(t = 15, r = 0, b = 0, l = 0)),
            legend.position = "right"
          )

        on.exit(stop_loading_bar(r, target_id = r$plot_id))


        return(plot)
      },
      res = 150
    )
  })
}

## To be copied in the UI
# mod_result_displayer_ui("result_displayer_1")

## To be copied in the server
# mod_result_displayer_server("result_displayer_1")
