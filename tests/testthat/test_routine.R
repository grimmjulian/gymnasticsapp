test_that("routine length 1 properties work", {
  r <- routine()
  expect_error(r@gymnast <- character(0), "length 1")
  expect_error(r@end_value <- c(1, 2), "length 1")
})

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
