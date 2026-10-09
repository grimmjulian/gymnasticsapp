#' @include routine.R

value_input <- function(
  inputId, # nolint: object_name_linter.
  label,
  value = 0,
  ...
) {
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
  dr <- routine()
  widths <- c(6, 3, 3)

  list(
    shiny::textInput(
      label = foo("Name"),
      ns("name"),
      value = dr@gymnast
    ),
    value_input(
      label = foo("D-Wert"),
      ns("d_value"),
      value = dr@d_value
    ),
    value_input(
      label = foo("Endwert"),
      ns("end_value"),
      value = dr@end_value
    )
  ) |>
  Map(f = shiny::column, width = widths) |>
  shiny::fluidRow() |>
  shiny::tagList()
}

routine_server <- function(id) {
  shiny::moduleServer(id, function(input, output, session) {
    shiny::reactive(routine(
      input$name,
      as.double(input$d_value),
      as.double(input$end_value)
    ))
  })
}
