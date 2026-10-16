test_that("defaults for competition works", {
  c <- competition()
  expect_length(c@events, 6)
  expect_true(all(sapply(c@events, inherits, what = event)))
})


test_that("score property works", {
  c <- competition()
  expect_equal(c@score, c(0, 0))
  e <- event()
  r <- routine(gymnast = "Julian", end_value = 4)
  e@home[[1]] <- r
  e@guest[[2]] <- routine(end_value = 1)
  c@events[[3]] <- e

  expect_equal(c@score, c(5, 3))
})

test_that("event score property works", {
  c <- competition()
  expect_equal(c@event_score, c(6, 6))
  e <- event()
  r <- routine(gymnast = "Julian", end_value = 4)
  e@home[[1]] <- r
  e@guest[[2]] <- routine(end_value = 1)
  c@events[[3]] <- e

  expect_equal(c@event_score, c(7, 5))
})
