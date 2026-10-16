test_that("defaults for event works", {
  e <- event()
  expect_length(e@home, 4)
  expect_length(e@guest, 4)
  expect_true(all(sapply(e@home, inherits, what = routine)))
  expect_true(all(sapply(e@guest, inherits, what = routine)))
})

test_that("setting pairings works", {
  e <- event()
  p1 <- pairing(home = routine(end_value = 1))
  p2 <- pairing(guest = routine(end_value = 2))
  e@pairings <- list(pairing(), p1, p2, pairing())
  expect_equal(e@home[[2]]@end_value, 1)
  expect_equal(e@guest[[3]]@end_value, 2)
})

test_that("pairings property works", {
  e <- event()
  r <- routine(gymnast = "Julian", end_value = 4)
  e@home[[1]] <- r
  e@guest[[2]] <- routine(end_value = 1)

  expect_equal(e@pairings[[1]]@home@gymnast, "Julian")
})

test_that("score property works", {
  e <- event()
  expect_equal(e@score, c(0, 0))
  r <- routine(gymnast = "Julian", end_value = 4)
  e@home[[1]] <- r
  e@guest[[2]] <- routine(end_value = 1)

  expect_equal(e@score, c(5, 3))
})

test_that("event score property works", {
  e <- event()
  expect_equal(e@event_score, c(1, 1))
  r <- routine(gymnast = "Julian", end_value = 4)
  e@home[[1]] <- r
  e@guest[[2]] <- routine(end_value = 1)
  expect_equal(e@event_score, c(2, 0))
})
