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
          rsconnect
        ];
      };
      document = pkgs.writeShellApplication {
        name = "document";
        runtimeInputs = [
          rEnv
        ];
        text = ''
          Rscript -e "roxygen2::roxygenize()"
          Rscript -e "rsconnect::writeManifest()"
        '';
      };
      devAppScript = pkgs.writeShellApplication {
        name = "dev-app";
        runtimeInputs = [ rEnv ];
        text = ''
          Rscript -e "shiny::runApp('app.R')"
        '';
      };
      texEnv = (
        pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-small inconsolata;
        }
      );
      testScript = pkgs.writeShellApplication {
        name = "r-tests";
        runtimeInputs = [ rEnv ];
        text = ''
          Rscript -e "testthat::test_local()"
        '';
      };
      checkScript = pkgs.writeShellApplication {
        name = "r-check";
        runtimeInputs = [ rEnv ];
        text = ''
          R CMD build .
          R CMD check ./*_*.tar.gz
        '';
      };
    in
    {
      apps.${system} = {
        test = {
          type = "app";
          program = "${testScript}/bin/r-tests";
        };
        document = {
          type = "app";
          program = "${document}/bin/document";
        };
        dev = {
          type = "app";
          program = "${devAppScript}/bin/dev-app";
        };
        check = {
          type = "app";
          program = "${checkScript}/bin/r-check";
        };
      };
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          rEnv
          texEnv
          air-formatter
          jarl
          nixfmt
          nil
          just
        ];
      };
      formatter.${system} = pkgs.writeShellApplication {
        name = "custom-formatter";
        runtimeInputs = [
          pkgs.air-formatter
          pkgs.nixfmt
        ];
        text = ''
          nixfmt flake.nix
          air format .
        '';
      };
    };
}
