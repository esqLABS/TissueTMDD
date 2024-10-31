label_tooltip <- function(label, content) {
  list(
    label,
    tooltip(
      span(bsicons::bs_icon("info-circle")),
      title = content
    )
  )
}
