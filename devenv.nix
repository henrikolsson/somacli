{ pkgs, ... }:

{
  packages = [ pkgs.git ];

  languages.go.enable = true;

  pre-commit.hooks = {
    gofmt.enable = true;
    nixfmt-rfc-style.enable = true;
  };
}
