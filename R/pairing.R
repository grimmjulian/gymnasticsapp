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

pairing_ui <- function(id, show_label = FALSE) {
  ns <- shiny::NS(id)
  widths <- c(5, 1, 5, 1)
  list(
    routine_ui(ns("home"), show_label = show_label),
    shiny::verbatimTextOutput(ns("score_home")),
    routine_ui(ns("guest"), show_label = show_label),
    shiny::verbatimTextOutput(ns("score_guest"))
  ) |>
    Map(f = shiny::column, width = widths) |>
    shiny::fluidRow() |>
    shiny::tagList()
}

pairing_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    r1 <- routine_server("home")
    r2 <- routine_server("guest")
    p <- shiny::reactive(pairing(home = r1(), guest = r2()))
    output$score_home <- shiny::renderText(p()@score[[1]])
    output$score_guest <- shiny::renderText(p()@score[[2]])
    p
  })
}
