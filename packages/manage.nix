{
  lib,
  writers,
  python3,
  nvd,
  git,
  ripgrep,
  nh,
}: let
  deps = [
    nvd
    git
    ripgrep
    nh
  ];
  python_deps = with python3.pkgs; [
    argcomplete
    rich
  ];
in (writers.writePython3Bin "manage" {
  libraries = python_deps;
  doCheck = false;
  makeWrapperArgs = ["--prefix" "PATH" ":" "${lib.makeBinPath deps}"];
} (builtins.readFile ../bin/manage.py))
