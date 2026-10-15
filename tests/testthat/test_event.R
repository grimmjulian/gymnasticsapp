test_that("defaults for event works", {
  e <- event()
  expect_length(e@home, 4)
  expect_length(e@guest, 4)
  expect_true(all(sapply(e@home, inherits, what = routine)))
  expect_true(all(sapply(e@guest, inherits, what = routine)))
})

test_that("pairings property works", {
  e <- event()
  r <- routine(gymnast = "Julian", end_value = 4)
  e@home[[1]] <- r
  e@guest[[2]] <- routine(end_value = 1)

  expect_equal(e@pairings[[1]]@home@gymnast, "Julian")
  expect_equal(e@score, c(5, 3))
})
