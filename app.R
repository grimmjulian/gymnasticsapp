
ui <- shiny::fluidPage(
  routine_ui("c", show_label = TRUE),
  pairing_ui("p", show_label = TRUE)
)
server <- function(input, output, session) {
  routine_server("c")
  pairing_server("p")
}
shiny::shinyApp(ui, server)
