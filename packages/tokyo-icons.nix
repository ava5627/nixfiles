{ stdenv
, fetchFromGitHub
, gtk-engine-murrine
}:

stdenv.mkDerivation {
  pname = "tokyo-night-icons";
  version = "unstable-2024-02-29";

  src = fetchFromGitHub {
    owner = "ava5627";
    repo = "TokyoNightIcons";
    rev = "793b6939e07dc254a504c469205710f12231e05c";
    sha256 = "91UAM+D4ZvW2iTwz+hGhG+nv1yzCOmyuSGRIqskIaFk=";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/Tokyonight-Ava/
    cp -r icons/* $out/share/icons/Tokyonight-Ava/
    runHook postInstall
  '';
}
