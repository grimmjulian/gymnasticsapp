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
      writeManifestScript = pkgs.writeShellApplication {
        name = "write-manifest";
        runtimeInputs = [ rEnv ];
        text = ''
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
    in
    {
      packages.${system}.default = pkgs.rPackages.buildRPackage {
        name = "roland.shiny";
        version = "0.1.0";
        src = ./.;

        propagatedBuildInputs = with pkgs.rPackages; [
          S7
          shiny

          texEnv
        ];
        doCheck = true;
        checkInputs = with pkgs.rPackages; [
          testthat
        ];
        checkPhase = ''
          runHook preCheck
          R CMD build .
          R CMD check *_*.tar.gz
          runHook postCheck
        '';
      };
      apps.${system} = {
        test = {
          type = "app";
          program = "${testScript}/bin/r-tests";
        };
        writeManifest = {
          type = "app";
          program = "${writeManifestScript}/bin/write-manifest";
        };
        dev = {
          type = "app";
          program = "${devAppScript}/bin/dev-app";
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
