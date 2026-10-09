
ui <- shiny::fluidPage(
  routine_ui("c", show_label = TRUE)
)
server <- function(input, output, session) {
  routine_server("c")
}
shiny::shinyApp(ui, server)
