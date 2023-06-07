testServer(
  mod_settings_exporter_server,
  # Add here your module params
  args = list()
  , {
    ns <- session$ns
    expect_true(
      inherits(ns, "function")
    )
    expect_true(
      grepl(id, ns(""))
    )
    expect_true(
      grepl("test", ns("test"))
    )
    # Here are some examples of tests you can
    # run on your module
    # - Testing the setting of inputs
    # session$setInputs(x = 1)
    # expect_true(input$x == 1)
    # - If ever your input updates a reactiveValues
    # - Note that this reactiveValues must be passed
    # - to the testServer function via args = list()
    # expect_true(r$x == 1)
    # - Testing output
    # expect_true(inherits(output$tbl$html, "html"))
  })

test_that("module ui works", {
  ui <- mod_settings_exporter_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(mod_settings_exporter_ui)
  for (i in c("id")){
    expect_true(i %in% names(fmls))
  }
})

test_that("get_settings_values_to_json works", {
  settings <- list("test_settings" = list(parameter1 = list(value = 1, othervalue="test"),
                                          parameter2 = list(othervalue="test", value = 1),
                                          paremeter3 = list(novalue = NA)))

  expect_snapshot(get_settings_values_to_json(settings))
})

