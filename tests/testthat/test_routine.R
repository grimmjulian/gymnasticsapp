test_that("routine_server works", {
  shiny::testServer(routine_server, {
    r <- session$getReturned()
    session$setInputs(
      name = "Julian",
      d_value = "14",
      end_value = "12"
    )

    expect_true(inherits(r(), routine))
  })
})
