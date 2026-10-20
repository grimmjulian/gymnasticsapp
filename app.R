source("R/10_score.R")
source("R/20_routine.R")
source("R/30_pairing.R")
source("R/40_event.R")
source("R/50_competition.R")

ui <- shiny::fluidPage(
  competition_ui("c")
)
server <- function(input, output, session) {
  competition_server("c")
}
shiny::shinyApp(ui, server)
