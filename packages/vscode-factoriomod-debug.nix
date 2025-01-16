{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:
buildNpmPackage rec {
  pname = "vscode-factoriomod-debug";
  version = "2.0.5";
  src = fetchFromGitHub {
    owner = "justarandomgeek";
    repo = pname;
    rev = version;
    sha256 = "0cwd5l17sicxfj2dwarzqp9plnfa0qk0h886fqa65r4qqnjk4qy1";
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [libsecret];
  npmDepsHash = "sha256-a/XHeRUUROJRyLTCYWLy2MYp1vvui7Vz7b1VDZN0eWo=";
  dontNpmBuild = true;

  meta = {
    description = "Factorio Mod Tool Kit";
    homepage = "https://github.com/justarandomgeek/vscode-factoriomod-debug";
    license = lib.licenses.mit;
  };
}
