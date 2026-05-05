# durdraw (Nix)

<!-- BEGIN generated:badges -->
[![NixOS unstable](https://img.shields.io/badge/NixOS-unstable-78C0E8?logo=nixos&logoColor=white)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
<!-- END generated:badges -->

Nix flake packaging for [durdraw](https://github.com/cmang/durdraw) by [Sam Foster (cmang)](https://github.com/cmang) — a Unicode, ANSI and ASCII art editor for the terminal.

![Python](https://img.shields.io/badge/Python-3.10+-blue)
![License BSD-3](https://img.shields.io/badge/License-BSD--3--Clause-green)
![Version 0.29.0](https://img.shields.io/badge/Version-0.29.0-orange)
![Platform](https://img.shields.io/badge/Platform-Linux-yellow)

<!-- BEGIN generated:upstream -->
## Upstream

| | |
|---|---|
| **Project** | [cmang/durdraw](https://github.com/cmang/durdraw) |
| **License** | BSD-3-Clause |
| **Tracked** | GitHub releases |
<!-- END generated:upstream -->

## What Is This?

A Nix flake that builds [durdraw](https://github.com/cmang/durdraw) from source with full CI infrastructure:

- **Package integrity** — SRI hashes for source, verified on every build
- **CI security** — pinned GitHub Actions (full SHA, not tags), minimal permissions, build-gated PRs
- **Upstream trust** — daily automated version detection, hash recomputation, and binary verification before push
- **Stale cleanup** — weekly flake.lock maintenance, stale branch cleanup

durdraw provides:

- **Unicode/ANSI/ASCII art editor** — full-featured terminal art editor with animation support
- **256-color and 16-color modes** — create art in multiple color depths
- **Animation** — frame-based animation with playback and export
- **PNG/GIF export** — export art to PNG and animated GIF (via Pillow and ansilove)
- **Includes durview and durfetch** — viewer and animated fetch utility

<!-- BEGIN generated:installation -->
## Installation

Add as a flake input:

```nix
{
  inputs.durdraw = {
    url = "github:Daaboulex/durdraw-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then add the overlay:

```nix
nixpkgs.overlays = [ inputs.durdraw.overlays.default ];
```
<!-- END generated:installation -->

## Usage

Launch the editor:

```bash
durdraw                          # new canvas
durdraw existing-art.dur         # open existing file
durdraw --width 80 --height 24   # custom canvas size
```

### Viewer and fetch utility

```bash
durview artwork.dur              # display art in terminal
durfetch                         # animated system fetch (like neofetch)
```

### Export

```bash
durdraw --export-png output.png input.dur
durdraw --export-gif output.gif input.dur
```
## Development

```bash
git clone https://github.com/Daaboulex/durdraw-nix
cd durdraw-nix
nix build
./result/bin/durdraw --help
```

## Updates

This repository uses automated daily checks via GitHub Actions to detect new upstream releases. When a new version is found:

1. Source hash is recomputed from the release tarball
2. Flake validation and test build must pass
3. Binary verification (`durdraw --help`) must succeed
4. Changes are pushed to main on success, or a diagnostic issue is created on failure

## License

This Nix packaging flake is provided as-is and carries no additional license terms.

The upstream [durdraw](https://github.com/cmang/durdraw) project by [Sam Foster](https://github.com/cmang) is licensed under the **BSD 3-Clause License**. See the [upstream LICENSE file](https://github.com/cmang/durdraw/blob/master/LICENSE) for full terms.

<!-- BEGIN generated:footer -->
---

*Maintained as part of the [Daaboulex](https://github.com/Daaboulex) NixOS ecosystem.*
<!-- END generated:footer -->
