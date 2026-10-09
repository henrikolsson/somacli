{
  description = "somacli - a simple TUI for listening to SomaFM";
  # Prebuilt outputs from CI. Nix asks before trusting these unless you're a
  # trusted user or accept-flake-config is set.
  nixConfig = {
    extra-substituters = [ "https://somacli.cachix.org" ];
    extra-trusted-public-keys = [ "somacli.cachix.org-1:6Wsa4ionmCH4FFaMchMbDA4pXM0rGgdaVz7I6Vc75OM=" ];
  };
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.go
            pkgs.gopls
            pkgs.devenv
          ];
        };
        packages.default = pkgs.buildGoModule rec {
          pname = "somacli";
          version = pkgs.lib.fileContents ./VERSION;
          src = ./.;
          vendorHash = "sha256-0YQ1WlPnvjRwg7nWJkOh3IdHhowBGbutbQOTPgBfxO4=";
          ldflags = [
            "-s"
            "-w"
            "-X main.version=${version}"
          ];
          meta = {
            description = "A simple TUI for listening to SomaFM";
            homepage = "https://github.com/henrikolsson/somacli";
            license = pkgs.lib.licenses.mit;
            mainProgram = "somacli";
          };
        };
      }
    );
}
