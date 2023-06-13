testServer(
  mod_settings_importer_server,
  # Add here your module params
  args = list(),
  {
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
  }
)

test_that("module ui works", {
  ui <- mod_settings_importer_ui(id = "test")
  golem::expect_shinytaglist(ui)
  # Check that formals have not been removed
  fmls <- formals(mod_settings_importer_ui)
  for (i in c("id")) {
    expect_true(i %in% names(fmls))
  }
})

test_that("read_settings_from_fileInput works", {
  file_df <- data.frame(
    name = "max_koff_tissuetmdd_settings.json",
    datapath = system.file("extdata/presets/max_koff_tissuetmdd_settings.json",
      package = "TissueTMDD"
    )
  )
  expect_snapshot(read_settings_from_fileInput(file_df))
})
