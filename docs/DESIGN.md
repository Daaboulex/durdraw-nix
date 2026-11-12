# Design

## The paths are upstream's

durdraw has no variable or flag for its paths, so they are what upstream
hardcodes. The file and line references below are to upstream's source at
0.31.1. They were recorded when the package moved to that release, in commit
c360294 of this repository, on 2026-10-23. To check them, read the same files
at upstream's `0.31.1` tag.

- `~/.config/durdraw/` is created at every start: `durdraw/log.py:52` fixes the
  log directory and `app_log_filepath` (`log.py:62-69`) refuses any other one.
  The log file itself, `durdraw.log`, appears only when something is logged at
  the configured level (WARNING unless `[Logging] level` says otherwise).
- Config is read from `/etc/durdraw/durdraw.ini`, `~/.durdraw/durdraw.ini` and
  `~/.config/durdraw/durdraw.ini` (`durdraw_appstate.py:342`).
- Choosing a theme in the editor writes its path to `~/.durdraw/theme-16` or
  `theme-256` (`durdraw_appstate.py:452-456`), and only when `~/.durdraw`
  already exists. durdraw never creates that directory.

## The one patch

Upstream's ANSI parser forces its logger to DEBUG at import
(`durdraw_ansiparse.py:27`), which overrides the WARNING default and appends
about 10 KB to `durdraw.log` on every start.

[package.nix](../package.nix) drops that override with
`substituteInPlace --replace-fail`, so the build fails, and names the line, on
the release that fixes it upstream.

The `smoke` check holds the result in place. It fails if durdraw writes
anything into an empty home beyond the directory `~/.config/durdraw/`, a log
file included. [DEVELOPMENT.md](DEVELOPMENT.md) describes the check.

## The export tools

PNG export goes through ansilove and animated GIF export through Pillow.
[package.nix](../package.nix) makes Pillow a dependency of the program and puts
ansilove on the `PATH` of its wrapper.
