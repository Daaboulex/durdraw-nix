# durdraw-nix

[durdraw](https://github.com/cmang/durdraw) packaged for NixOS — Unicode/ANSI/ASCII art editor for the terminal.

## Usage

### Flake

```nix
{
  inputs.durdraw.url = "github:Daaboulex/durdraw-nix";
}
```

### Overlay

```nix
nixpkgs.overlays = [ inputs.durdraw.overlays.default ];
```

### Run directly

```bash
nix run github:Daaboulex/durdraw-nix
```

## License

Packaging: MIT | Upstream: BSD-3-Clause
