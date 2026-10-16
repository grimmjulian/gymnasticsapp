ui <- shiny::fluidPage(
  pairing_ui("p", show_label = TRUE),
  event_ui("e")
)
server <- function(input, output, session) {
  pairing_server("p")
  event_server("e")
}
shiny::shinyApp(ui, server)
