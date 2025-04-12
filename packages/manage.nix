{
  symlinkJoin,
  makeWrapper,
  writeScriptBin,
  python3,
  nvd,
  git,
  ripgrep,
  nh,
}: let
  deps = [
    (python3.withPackages (ps:
      with ps; [
        argcomplete
        rich
      ]))
    nvd
    git
    ripgrep
    nh
  ];
  name = "manage";
  script = writeScriptBin name (
    builtins.replaceStrings ["#!/usr/bin/env nix-shell"] ["#!/usr/bin/env python3"] (builtins.readFile ../bin/manage.py)
  );
in
  symlinkJoin {
    name = name;
    paths = [script] ++ deps;
    buildInputs = [makeWrapper];
    postBuild = ''
      wrapProgram $out/bin/${name} --prefix PATH : $out/bin
    '';
  }
