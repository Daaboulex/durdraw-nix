# Development

```bash
git clone https://github.com/Daaboulex/durdraw-nix
cd durdraw-nix
nix build
./result/bin/durdraw --version
```

The flake's own `nixpkgs` input follows `nixos-unstable`.

## The check

`nix flake check` builds the `smoke` check that [flake.nix](../flake.nix)
defines. It takes `examples/cm-eye.dur`, an example bundled with upstream's
source, and runs `durdraw --export-ansi` on it in a pseudo-terminal under an
empty `HOME`.

It fails in two cases:

- the exported `art.ansi` holds no ANSI escape sequence
- the home holds anything other than the empty directory `.config/durdraw`

The second case is what catches a durdraw that writes outside its own config
directory, or that starts filling its log again.

CI is [.github/workflows/ci.yml](../.github/workflows/ci.yml). It runs on a
push to the main branch and on a pull request, through the shared workflow of
nix-packaging-standard.

## Updates

The package tracks the GitHub releases of
[cmang/durdraw](https://github.com/cmang/durdraw), which is BSD-3-Clause
licensed. [.github/update.json](../.github/update.json) declares that.

[.github/workflows/update.yml](../.github/workflows/update.yml) looks for a new
upstream release through GitHub Actions. It runs daily unless the
`UPDATE_CADENCE` repository variable says otherwise. When a new version is
found:

1. The source hash in [package.nix](../package.nix) is recomputed for the new
   release.
2. Flake validation and a test build must pass.
3. The `smoke` check must pass.
4. `durdraw --help` must run from the new build.
5. The change is pushed to main on success, or a diagnostic issue is created
   on failure.
