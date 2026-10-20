#' @include 30_pairing.R

event <- S7::new_class(
  name = "event",
  properties = list(
    home = S7::class_list,
    guest = S7::class_list,
    pairings = S7::new_property(
      getter = function(self) {
        mapply(pairing, home = self@home[1:4], guest = self@guest[1:4])
      },
      setter = function(self, value) {
        self@home[1:4] <- lapply(value, S7::prop, name = "home")
        self@guest[1:4] <- lapply(value, S7::prop, name = "guest")
        self
      },
      default = quote(replicate(4, pairing()))
    ),
    score = S7::new_property(
      getter = function(self) {
        self@pairings |> lapply(\(x) x@score) |> Reduce(f = `+`)
      }
    ),
    event_score = S7::new_property(
      getter = function(self) {
        s <- self@score
        if (s[[1]] > s[[2]]) {
          es <- c(2, 0)
        } else if (s[[1]] < s[[2]]) {
          es <- c(0, 2)
        } else {
          es <- c(1, 1)
        }
      }
    )
  )
)

event_result_ui <- function(id) {
  foo <- function(id, label) {
    list(label, shiny::verbatimTextOutput(id)) |>
      lapply(shiny::tags$b) |>
      lapply(shiny::column, width = 6) |>
      shiny::fluidRow() |>
      shiny::tagList()
  }

  ns <- shiny::NS(id)
  list(
    foo(ns("home_es"), "GP"),
    foo(ns("home_s"), "Score"),
    foo(ns("guest_es"), "GP"),
    foo(ns("guest_s"), "Score")
  ) |>
    lapply(shiny::column, width = 3) |>
    shiny::fluidRow() |>
    shiny::tagList()
}

event_result_server <- function(id, event) {
  stopifnot(shiny::is.reactive(event))
  shiny::moduleServer(id, function(input, output, session) {
    output$home_es <- shiny::renderText(event()@event_score[[1]])
    output$guest_es <- shiny::renderText(event()@event_score[[2]])
    output$home_s <- shiny::renderText(event()@score[[1]])
    output$guest_s <- shiny::renderText(event()@score[[2]])
  })
}

event_bench_team_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    "Anzahl Bankturner",
    shiny::verbatimTextOutput(ns("number")),
    shiny::actionButton(ns("add"), "Add to bench")
  )
}

event_bench_team_server <- function(id, event) {
  stopifnot(shiny::is.reactive(event))
  shiny::moduleServer(id, function(input, output, session) {
    e_local <- shiny::reactiveVal(shiny::isolate(event()))

    shiny::observeEvent(input$add, {
      e <- shiny::isolate(e_local())
      S7::prop(e, id) <- append(S7::prop(e, id), routine())
      e_local(e)
    })

    output$number <- shiny::renderText(length(S7::prop(e_local(), id)) - 4)
  })
}

event_bench_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::fluidRow(
      shiny::column(
        width = 6,
        event_bench_team_ui(ns("home"))
      ),
      shiny::column(
        width = 6,
        event_bench_team_ui(ns("guest"))
      )
    )
  )
}

event_bench_server <- function(id, event) {
  shiny::moduleServer(id, function(input, output, session) {
    event_bench_team_server("home", event)
    event_bench_team_server("guest", event)
  })
}

event_ui <- function(id, header = id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::tags$h2(header),
    pairing_ui(ns("1"), show_label = TRUE),
    pairing_ui(ns("2")),
    pairing_ui(ns("3")),
    pairing_ui(ns("4")),
    event_result_ui(ns("result")),
    event_bench_ui(ns("bench"))
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
      e@pairings <- list(p1(), p2(), p3(), p4())
      e
    })
    event_result_server("result", e)
    event_bench_server("bench", e)
    e
  })
}

S7::method(as.data.frame, event) <- function(x, ...) {
  df <- x@pairings |>
    lapply(as.data.frame) |>
    do.call(what = rbind)
  df[["pairing_order"]] <- seq_len(nrow(df))
  df
}
