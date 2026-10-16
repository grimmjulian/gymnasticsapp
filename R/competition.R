#' @include event.R
event_names <- c(
  "floor",
  "pommel_horse",
  "still_rings",
  "vault",
  "p_bar",
  "high_bar"
)

competition <- S7::new_class(
  name = "competition",
  properties = list(
    events = S7::new_property(
      S7::class_list,
      default = replicate(6, event()) |>
        stats::setNames(object = _, nm = event_names) |>
        quote()
    ),
    score = S7::new_property(
      getter = function(self) {
        self@events |> lapply(\(x) x@score) |> Reduce(f = `+`)
      }
    ),
    event_score = S7::new_property(
      getter = function(self) {
        self@events |> lapply(\(x) x@event_score) |> Reduce(f = `+`)
      }
    )
  )
)

competition_ui <- function(id) {
  ns <- shiny::NS(id)
  lapply(event_names, \(x) {
    event_ui(ns(x), x)
  }) |>
    shiny::tagList()
}

competition_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    for (event_name in event_names) {
      event_server(event_name)
    }
  })
}
