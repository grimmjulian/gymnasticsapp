calculate_score <- function(x, y) {
  breaks <- c(-Inf, 0.15, 0.3, 0.55, 1.05, 2.05, 6.05, Inf)
  labels <- c(0:5, 10)
  cut(x - y, breaks = breaks, labels = labels) |>
    as.character() |>
    as.numeric()
}
routine <- S7::new_class(
  name = "routine",
  properties = list(
    gymnast = S7::class_character,
    d_value = S7::class_double,
    end_value = S7::class_double
  )
)

valueInput <- function(inputId, label, value = 0, ...) {
  shiny::numericInput(
    inputId = inputId,
    label = label,
    value = value,
    min = 0,
    max = 20,
    step = 0.05,
    ...
  )
}

routine_ui <- function(id, show_label = FALSE) {
  ns <- shiny::NS(id)
  foo <- function(label) {
    if (isTRUE(show_label)) {
      label
    } else {
      NULL
    }
  }

  shiny::tagList(
    shiny::fluidRow(
      shiny::column(
        width = 5,
        shiny::textInput(label = foo("Name"), ns("name"), value = "Kein Turner")
      ),
      shiny::column(
        width = 2,
        valueInput(label = foo("D-Score"), ns("d_value"), value = 0)
      ),
      shiny::column(
        width = 2,
        valueInput(label = foo("E-Score"), ns("end_value"), value = 10)
      ),
      shiny::column(
        width = 2,
        shiny::textOutput(ns("score"))
      ),
      shiny::column(
        width = 1,
        shiny::actionButton(ns("deletebutton"), label = "x")
      )
    )
  )
}

routine_server <- function(id, score_comparison_value = 10) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::observeEvent(input$deletebutton, {
      shiny::updateTextInput(session, "name", value = "Kein Turner")
      shiny::updateNumericInput(session, "d_value", value = 0)
      shiny::updateNumericInput(session, "end_value", value = 0)
    })
    output$score <- shiny::renderText(calculate_score(
      input$end_value,
      score_comparison_value
    ))
    shiny::reactive(routine(
      input$name,
      as.double(input$d_value),
      as.double(input$end_value)
    ))
  })
}

event_side_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    routine_ui(ns("a"), TRUE),
    routine_ui(ns("b"), FALSE),
    routine_ui(ns("c"), FALSE),
    routine_ui(ns("d"), FALSE),
    shiny::fluidRow(
      shiny::column(width = 6, "Total: "),
      shiny::column(width = 6, shiny::textOutput(ns("total")))
    )
  )
}

event_side_server <- function(id, score_comparison_values = 1:4) {
  shiny::moduleServer(id, function(input, output, session) {
    l <- list(
      routine_server("a", score_comparison_values[1]),
      routine_server("b", score_comparison_values[2]),
      routine_server("c", score_comparison_values[3]),
      routine_server("d", score_comparison_values[4])
    )
    output$total <- shiny::reactive(
      l |>
        lapply(\(x) x()@end_value) |>
        Reduce(f = `+`)
    )
    l
  })
}

event_ui <- function(id) {
  ns <- shiny::NS(id)
  shiny::tagList(
    shiny::fluidRow(
      shiny::column(width = 6, "Heim", event_side_ui(ns("home"))),
      shiny::column(width = 6, "Gast", event_side_ui(ns("guest")))
    )
  )
}

event_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    event_side_server("home")
    event_side_server("guest")
  })
}
ui <- shiny::fluidPage(
  event_ui("c")
)
server <- function(input, output, session) {
  event_server("c")
}
shiny::shinyApp(ui, server)
