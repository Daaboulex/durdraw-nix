# durdraw (Nix)

A Nix flake that builds [durdraw](https://github.com/cmang/durdraw) from
source. durdraw is a Unicode, ANSI and ASCII art editor for the terminal, by
[Sam Foster (cmang)](https://github.com/cmang). The flake is for anyone who
wants it as a Nix package or through an overlay.

It is packaged for `x86_64-linux` and `aarch64-linux`. One automated check runs
the built program: it exports one of upstream's example drawings to ANSI from
the command line. The editor screen, `durview`, `durfetch` and the PNG and GIF
export are not covered by any check here.

## What you get

- `durdraw`, the editor, with frame-based animation, playback and export.
- 256-color and 16-color modes.
- Export to PNG and to animated GIF. The two tools they need, ansilove and
  Pillow, come with the package.
- `durview`, a viewer, and `durfetch`, an animated fetch utility.

## Install

Add the flake:

```nix
{
  inputs.durdraw = {
    url = "github:Daaboulex/durdraw-nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
}
```

Then add the overlay and install the package:

```nix
{
  nixpkgs.overlays = [ inputs.durdraw.overlays.default ];
  environment.systemPackages = [ pkgs.durdraw ];
}
```

To try it without installing anything:

```bash
nix run github:Daaboulex/durdraw-nix
```

## Use

| Command | What it does |
|---|---|
| `durdraw` | Open the editor on a new canvas |
| `durdraw existing-art.dur` | Open an existing file |
| `durdraw --width 80 --height 24` | Open the editor with a custom canvas size |
| `durview artwork.dur` | Display art in the terminal |
| `durfetch` | Show an animated system fetch, like neofetch |
| `durdraw --export-ansi input.dur` | Write `input.ansi` next to the file, then exit |

PNG and animated GIF export are in the editor's save menu. PNG goes through
ansilove and GIF through Pillow.

## Where durdraw writes

durdraw has no variable or flag for its paths, so they are the ones upstream
hardcodes.

- `~/.config/durdraw/` is created at every start. The log file goes there.
- Config is read from `/etc/durdraw/durdraw.ini`, `~/.durdraw/durdraw.ini` and
  `~/.config/durdraw/durdraw.ini`.
- Choosing a theme in the editor writes its path to `~/.durdraw/theme-16` or
  `~/.durdraw/theme-256`.

`~/.durdraw` sits in the home root and cannot be moved. Upstream 0.31.1
hardcodes it in `durdraw_appstate.py`, at line 342 for the config file and at
lines 452 to 456 for the theme.

## Known limits

- PNG and GIF export cannot be started from the command line. Upstream has no
  flag for them.
- None of the paths above can be changed.
- A theme choice is written only when `~/.durdraw` already exists. durdraw
  never creates that directory.

## When something does not work

durdraw logs to `~/.config/durdraw/durdraw.log`. The file appears only when
something is logged at the configured level. That level is WARNING unless
`level` under `[Logging]` in `durdraw.ini` says otherwise.

The package removes one upstream line that otherwise fills this log with debug
output at every start. [docs/DESIGN.md](docs/DESIGN.md) has the detail.

## More

- [docs/DESIGN.md](docs/DESIGN.md): the paths upstream hardcodes, with the
  source lines that prove them, and the one patch the package carries
- [docs/DEVELOPMENT.md](docs/DEVELOPMENT.md): building, the check, how updates
  arrive
- [SECURITY.md](SECURITY.md): how to report a vulnerability

## License

This packaging flake is [MIT](./LICENSE) licensed. Upstream [durdraw](https://github.com/cmang/durdraw) is BSD-3-Clause.

The upstream [durdraw](https://github.com/cmang/durdraw) project by [Sam Foster](https://github.com/cmang) is licensed under the **BSD 3-Clause License**. See the [upstream LICENSE file](https://github.com/cmang/durdraw/blob/master/LICENSE) for full terms.
