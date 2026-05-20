{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  pkg-config,
  libsecret,
}:
buildNpmPackage rec {
  pname = "vscode-factoriomod-debug";
  version = "2.0.14";
  src = fetchFromGitHub {
    owner = "justarandomgeek";
    repo = pname;
    rev = version;
    sha256 = "1vdphinmgjd5nmcy8r9bxjrsc3lay9p080247abgcxh8yjx85s8a";
  };

  nativeBuildInputs = [pkg-config];
  buildInputs = [libsecret];
  npmDepsHash = "sha256-Msv5/IMS18jgsiz4dXrfxns2K90/1uRhgGMrOO4qe6Y=";
  dontNpmBuild = true;

  meta = {
    description = "Factorio Mod Tool Kit";
    homepage = "https://github.com/justarandomgeek/vscode-factoriomod-debug";
    license = lib.licenses.mit;
  };
}
