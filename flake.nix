{
  description = "Nix flake for durdraw — Unicode/ANSI/ASCII art editor for the terminal";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    std = {
      url = "github:Daaboulex/nix-packaging-standard/release";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.git-hooks.follows = "git-hooks";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "x86_64-linux"
        "aarch64-linux"
      ];

      imports = [ inputs.std.flakeModules.base ];

      perSystem =
        { pkgs, self', ... }:
        {
          packages.default = pkgs.callPackage ./package.nix { };

          checks.smoke =
            pkgs.runCommand "durdraw-smoke"
              {
                nativeBuildInputs = [ pkgs.util-linux ];
                art = "${self'.packages.default.src}/examples/cm-eye.dur";
              }
              ''
                export HOME="$TMPDIR/home" TERM=xterm-256color TERMINFO_DIRS=${pkgs.ncurses}/share/terminfo
                mkdir -p "$HOME"
                install -m 644 "$art" art.dur
                script -qec "${pkgs.lib.getExe self'.packages.default} --export-ansi art.dur" /dev/null
                if ! grep -q $'\e\\[' art.ansi; then
                  echo "durdraw --export-ansi wrote no ANSI art to art.ansi"
                  exit 1
                fi
                written=$(cd "$HOME" && find . -mindepth 1 | sort | tr '\n' ' ')
                if [ "$written" != "./.config ./.config/durdraw " ]; then
                  echo "durdraw wrote outside its own config directory: $written"
                  exit 1
                fi
                touch "$out"
              '';
        };

      flake.overlays.default = final: _prev: {
        durdraw = final.callPackage ./package.nix { };
      };
    };
}
