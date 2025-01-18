# somacli

A simple TUI for listening to [SomaFM](https://somafm.com/).

<picture>
  <source media="(prefers-color-scheme: dark)" srcset="https://dump.fixme.se/somacli/demo.gif">
  <source media="(prefers-color-scheme: light)" srcset="https://dump.fixme.se/somacli/demo.gif">
  <img width="600" alt="A GIF produced by the VHS code above" src="https://dump.fixme.se/somacli/demo.gif">
</picture>

# Usage

## Requirements

* [mpv](https://mpv.io/) available in PATH

## Installing

Either download a release from [GitHub](https://github.com/henrikolsson/somacli/releases), or use [nix](https://nixos.org) to run it directly:

```
nix run github:henrikolsson/somacli
```

# Building

Use either nix:

```
nix build
```

Or go:

```
go build
```
