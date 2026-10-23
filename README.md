# durdraw (Nix)

<!-- BEGIN generated:badges -->
[![CI](https://github.com/Daaboulex/durdraw-nix/actions/workflows/ci.yml/badge.svg)](https://github.com/Daaboulex/durdraw-nix/actions/workflows/ci.yml)
[![NixOS unstable](https://img.shields.io/badge/NixOS-unstable-78C0E8?logo=nixos&logoColor=white)](https://nixos.org)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
<!-- END generated:badges -->

Nix flake packaging for [durdraw](https://github.com/cmang/durdraw) by [Sam Foster (cmang)](https://github.com/cmang) — a Unicode, ANSI and ASCII art editor for the terminal.

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
durdraw --export-ansi input.dur   # writes input.ansi next to it, then exits
```

PNG and animated GIF export live in the editor's save menu (PNG through
ansilove, GIF through Pillow); upstream has no command-line flag for them.

## Where durdraw writes

durdraw has no variable or flag for its paths, so they are what upstream
hardcodes (0.31.1):

- `~/.config/durdraw/` is created at every start: `durdraw/log.py:52` fixes the
  log directory and `app_log_filepath` (`log.py:62-69`) refuses any other one.
  The log file itself, `durdraw.log`, appears only when something is logged at
  the configured level (WARNING unless `[Logging] level` says otherwise).
- Config is read from `/etc/durdraw/durdraw.ini`, `~/.durdraw/durdraw.ini` and
  `~/.config/durdraw/durdraw.ini` (`durdraw_appstate.py:342`).
- Choosing a theme in the editor writes its path to `~/.durdraw/theme-16` or
  `theme-256` (`durdraw_appstate.py:452-456`), and only when `~/.durdraw`
  already exists; durdraw never creates that directory.

Upstream's ANSI parser forces its logger to DEBUG at import
(`durdraw_ansiparse.py:27`), which overrides the WARNING default and appends
about 10 KB to `durdraw.log` on every start. `package.nix` drops that override
with `substituteInPlace --replace-fail`, so the build fails, and names the
line, on the release that fixes it upstream. The `smoke` check exports a
bundled example to ANSI under an empty `HOME` and fails if durdraw writes
anything there beyond `~/.config/durdraw/`.

## Development

```bash
git clone https://github.com/Daaboulex/durdraw-nix
cd durdraw-nix
nix build
./result/bin/durdraw --version
```

## Updates

This repository uses automated daily checks via GitHub Actions to detect new upstream releases. When a new version is found:

1. Source hash is recomputed from the release tarball
2. Flake validation and test build must pass
3. The `smoke` check must pass: a bundled example exported to ANSI under an empty `HOME`, writing nothing outside `~/.config/durdraw/`
4. Changes are pushed to main on success, or a diagnostic issue is created on failure

## License

This packaging flake is [MIT](./LICENSE) licensed. Upstream [durdraw](https://github.com/cmang/durdraw) is BSD-3-Clause.

The upstream [durdraw](https://github.com/cmang/durdraw) project by [Sam Foster](https://github.com/cmang) is licensed under the **BSD 3-Clause License**. See the [upstream LICENSE file](https://github.com/cmang/durdraw/blob/master/LICENSE) for full terms.

<!-- BEGIN generated:footer -->
<!-- END generated:footer -->
