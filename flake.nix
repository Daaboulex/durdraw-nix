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
      url = "github:Daaboulex/nix-packaging-standard?ref=v2.7.1";
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

          checks.smoke = pkgs.runCommand "durdraw-smoke" { } ''
            ${self'.packages.default}/bin/durdraw --help > /dev/null
            touch "$out"
          '';
        };

      flake.overlays.default = final: _prev: {
        durdraw = inputs.self.packages.${final.system}.default;
      };
    };
}
