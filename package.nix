{
  lib,
  python3Packages,
  fetchFromGitHub,
  ansilove,
}:

let
  version = "0.29.0";
in
python3Packages.buildPythonApplication {
  pname = "durdraw";
  inherit version;
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cmang";
    repo = "durdraw";
    rev = version;
    hash = "sha256-a+4DGWBD5XLaNAfTN/fmI/gALe76SCoWrnjyglNhVPY=";
  };

  build-system = with python3Packages; [
    setuptools
    wheel
  ];

  dependencies = with python3Packages; [
    pillow
  ];

  makeWrapperArgs = [
    "--prefix PATH : ${lib.makeBinPath [ ansilove ]}"
  ];

  meta = {
    description = "Unicode, ANSI and ASCII art editor for the terminal";
    homepage = "https://github.com/cmang/durdraw";
    changelog = "https://github.com/cmang/durdraw/releases/tag/${version}";
    license = lib.licenses.bsd3;
    mainProgram = "durdraw";
  };
}
