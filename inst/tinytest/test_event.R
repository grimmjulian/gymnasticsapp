e <- event()
r <- routine(gymnast = "Julian", end_value = 4)
e@home[[1]] <- r
e@guest[[2]] <- routine(end_value = 1)

expect_equal(e@pairings[[1]]@home@gymnast, "Julian")
expect_equal(e@score, c(5, 3))
