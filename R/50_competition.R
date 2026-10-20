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

competition_header_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(shiny::tags$div(
    class = "text-center",
    shiny::tags$h1(shiny::textOutput(ns("score"))),
    shiny::tags$h2(shiny::textOutput(ns("event_score")))
  ))
}

competition_header_server <- function(id, competition) {
  stopifnot(shiny::is.reactive(competition))
  shiny::moduleServer(id, function(input, output, session) {
    output$score <- shiny::renderText({
      competition()@score |> paste(collapse = " : ")
    })
    output$event_score <- shiny::renderText({
      competition()@event_score |> paste(collapse = " : ")
    })
  })
}


competition_ui <- function(id) {
  ns <- shiny::NS(id)
  lapply(event_names, \(x) {
    event_ui(ns(x), x)
  }) |>
    shiny::tagList(
      competition_header_ui(ns("header")),
      a = _,
      shiny::downloadButton(ns("downloadData"), "Download")
    )
}

#' @importFrom utils write.csv
competition_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    rv <- shiny::reactiveValues()
    for (event_name in event_names) {
      rv[[event_name]] <- event_server(event_name)
    }
    c <- shiny::reactive({
      c <- competition()
      for (event_name in event_names) {
        c@events[[event_name]] <- rv[[event_name]]()
      }
      c
    })
    competition_header_server("header", c)
    output$downloadData <- shiny::downloadHandler(
      filename = function() {
        paste("data-", Sys.Date(), ".csv", sep = "")
      },
      content = function(file) {
        as.data.frame(c()) |>
          write.csv(file)
      }
    )
  })
}

S7::method(as.data.frame, competition) <- function(x, ...) {
  l <- list()
  for (i in seq_along(x@events)) {
    l[[i]] <- as.data.frame(x@events[[i]])
    l[[i]][["event_order"]] <- i
    l[[i]][["event"]] <- names(x@events)[[i]]
  }
  do.call(what = rbind, args = l)
}
