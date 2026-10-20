source("R/score.R")
source("R/routine.R")
source("R/event.R")
source("R/pairing.R")
source("R/competition.R")

options(shiny.autoload.r = FALSE)

ui <- shiny::fluidPage(
  competition_ui("c")
)
server <- function(input, output, session) {
  competition_server("c")
}
shiny::shinyApp(ui, server)
