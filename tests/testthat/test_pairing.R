test_that("score property works", {
  p <- pairing()
  r <- routine(end_value = 1)

  expect_equal(p@score, c(0, 0))

  p <- pairing(home = r)
  expect_equal(p@score, c(3, 0))

  p <- pairing(guest = r)
  expect_equal(p@score, c(0, 3))
})
