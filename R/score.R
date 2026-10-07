calculate_score <- function(x) {
  breaks <- c(-Inf, 0.15, 0.3, 0.55, 1.05, 2.05, 6.05, Inf)
  labels <- c(0:5, 10)
  y <- x
  i <- 1
  s <- c(0, 0)
  if (x < 0) {
    y <- -x
    i <- 2
  }
  s[[i]] <- cut(y, breaks = breaks, labels = labels) |>
    as.character() |>
    as.numeric()
  s
}
