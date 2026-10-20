pkgload::load_all(".")
options(shiny.autoload.r=FALSE)

ui <- shiny::fluidPage(
  competition_ui("c")
)
server <- function(input, output, session) {
  competition_server("c")
}
shiny::shinyApp(ui, server)
