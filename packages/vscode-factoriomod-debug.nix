{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:
buildNpmPackage rec {
  pname = "vscode-factoriomod-debug";
  version = "2.1.6";
  src = fetchFromGitHub {
    owner = "justarandomgeek";
    repo = pname;
    rev = version;
    sha256 = "0d91jinp2sw83va7pjw6s6j3xznapsz51b5c8wl3dwclx6xc2jdd";
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [libsecret];
  npmDepsHash = "sha256-CncU43Q59dEVxHVU3UQCqRALosY1/Gt4v3m4FDRvsGw=";
  dontNpmBuild = true;

  meta = {
    description = "Factorio Mod Tool Kit";
    homepage = "https://github.com/justarandomgeek/vscode-factoriomod-debug";
    license = lib.licenses.mit;
  };
}
