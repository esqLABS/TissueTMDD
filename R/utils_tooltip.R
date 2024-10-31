label_tooltip <- function(label, content) {
  list(
    label,
    bs4Dash::tooltip(
      span(bsicons::bs_icon("info-circle")),
      title = content
    )
  )
}
