run:
    Rscript -e "options(shiny.autoload.r = TRUE); shiny::runApp(display.mode = 'normal')"

doc: 
    Rscript -e "roxygen2::roxygenize()"

test: doc
    Rscript -e "pkgload::load_all(path = '.'); tinytest::test_all()"
