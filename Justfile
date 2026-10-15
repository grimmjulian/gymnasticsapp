run:
    Rscript -e "options(shiny.autoload.r = FALSE, shiny.autoreload = TRUE); pkgload::load_all(path = '.'); shiny::runApp()"

doc: 
    Rscript -e "roxygen2::roxygenize()"

test:
    nix run .#test

build: doc
    echo "funny just build"

check: build
    nix build
