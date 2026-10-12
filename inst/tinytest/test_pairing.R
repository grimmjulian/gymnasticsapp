p <- pairing()
r <- routine(end_value = 1)

expect_equal(p@score, c(0, 0))

p <- pairing(home = r)
expect_equal(p@score, c(3, 0))

p <- pairing(guest = r)
expect_equal(p@score, c(0, 3))

shiny::testServer(pairing_server, {
  p <- session$getReturned()
  r1 <- shiny::reactive(routine())
  r2 <- shiny::reactive(routine())
  session$flushReact()

  expect_true(inherits(p(), pairing))
})
