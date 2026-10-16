#' @include pairing.R

event <- S7::new_class(
  name = "event",
  properties = list(
    home = S7::new_property(
      S7::class_list
    ),
    guest = S7::new_property(
      S7::class_list
    ),
    pairings = S7::new_property(
      getter = function(self) {
        mapply(pairing, home = self@home, guest = self@guest)
      },
      setter = function(self, value) {
        self@home <- lapply(value, S7::prop, name = "home")
        self@guest <- lapply(value, S7::prop, name = "guest")
        self
      },
      default = quote(replicate(4, pairing()))
    ),
    score = S7::new_property(
      getter = function(self) {
        self@pairings |> lapply(\(x) x@score) |> Reduce(f = `+`)
      }
    )
  )
)

event_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    pairing_ui(ns("1"), show_label = TRUE),
    pairing_ui(ns("2")),
    pairing_ui(ns("3")),
    pairing_ui(ns("4"))
  )
}

event_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    p1 <- pairing_server("1")
    p2 <- pairing_server("2")
    p3 <- pairing_server("3")
    p4 <- pairing_server("4")
    e <- shiny::reactive({
      e <- event()
      e@pairings <- list(p1, p2, p3, p4)
      e
    })
    e
  })
}
