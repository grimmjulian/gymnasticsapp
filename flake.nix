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
      texEnv = (
        pkgs.texlive.combine {
          inherit (pkgs.texlive) scheme-small inconsolata;
        }
      );
    in
    {
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
    };
}
