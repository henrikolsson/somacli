{
  description = "A very basic flake";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      devShells.default = pkgs.mkShell {
        packages = [ pkgs.go pkgs.gopls ];
      };
      packages.default = pkgs.buildGoModule {
        pname = "somacli";
        version = "1.0.0";
        src = ./.;
        vendorHash = "sha256-wGnlYMgnxorzpTSxjFf+2WDExFHX+IEMyVvQ4bIPGAc=";
      };
    });
}
