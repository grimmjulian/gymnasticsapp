{
  description = "A very basic shiny flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      rEnv = pkgs.rWrapper.override {
        packages = with pkgs.rPackages; [
          shiny
          languageserver
          S7
          testthat
          roxygen2
          watcher
        ];

      };
    in
    {

      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          rEnv
          air-formatter
          jarl
          nixfmt
          nil
          just
        ];
      };
      apps.${system}.default = {
        type = "app";
        program = toString (
          pkgs.writeShellScript "run-shiny-app" ''
            export PATH="${rEnv}/bin:$PATH"
            Rscript -e "options(browser = 'firefox');shiny::runApp('${self}/app.R', port = 3838, host = '0.0.0.0')"
          ''
        );
      };
    };
}
