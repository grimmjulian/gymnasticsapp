run:
    Rscript -e "options(shiny.autoload.r = FALSE, shiny.autoreload = TRUE); pkgload::load_all(path = '.'); shiny::runApp()"

doc: 
    Rscript -e "roxygen2::roxygenize()"

test: doc
    Rscript -e "pkgload::load_all(path = '.'); tinytest::test_all()"

build: doc
    R CMD build .

check: build
    R CMD check *_*.tar.gz
