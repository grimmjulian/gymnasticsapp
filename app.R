pkgload::load_all(".")
ui <- shiny::fluidPage(
  competition_ui("c")
)
server <- function(input, output, session) {
  competition_server("c")
}
shiny::shinyApp(ui, server)
