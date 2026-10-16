#' @include routine.R
#' @include score.R

pairing <- S7::new_class(
  name = "pairing",
  properties = list(
    home = routine,
    guest = routine,
    score = S7::new_property(
      getter = function(self) {
        x <- self@home@end_value - self@guest@end_value
        calculate_score(x)
      }
    )
  )
)

score_ui <- function(id, show_label = FALSE) {
  ns <- shiny::NS(id)
  if (isTRUE(show_label)) {
    label <- "Score"
  } else {
    label <- NULL
  }
  list(
    label,
    shiny::verbatimTextOutput(ns("score"))
  ) |>
    shiny::tagList()
}

score_server <- function(id, score) {
  stopifnot(shiny::is.reactive(score))
  shiny::moduleServer(id, function(input, output, session) {
    output$score <- shiny::renderText(score())
  })
}

pairing_ui <- function(id, show_label = FALSE) {
  ns <- shiny::NS(id)
  if (isTRUE(show_label)) {
    header <- c("Heim", "Gast") |>
      lapply(shiny::column, width = 6) |>
      shiny::fluidRow()
  } else {
    header <- NULL
  }
  widths <- c(5, 1, 5, 1)
  list(
    routine_ui(ns("home"), show_label = show_label),
    score_ui(ns("score_home"), show_label = show_label),
    routine_ui(ns("guest"), show_label = show_label),
    score_ui(ns("score_guest"), show_label = show_label)
  ) |>
    Map(f = shiny::column, width = widths) |>
    shiny::fluidRow() |>
    shiny::tagList(header, a = _)
}

pairing_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    r1 <- routine_server("home")
    r2 <- routine_server("guest")
    p <- shiny::reactive(pairing(home = r1(), guest = r2()))
    s1 <- shiny::reactive(p()@score[[1]])
    s2 <- shiny::reactive(p()@score[[2]])
    score_server("score_home", s1)
    score_server("score_guest", s2)
    p
  })
}
