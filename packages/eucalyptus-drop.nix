{
  stdenvNoCC,
  fetchFromGitLab,
  qt6,
  background_image ? ../config/camp_fire.jpg,
}:
stdenvNoCC.mkDerivation {
  name = "eucalyptus-drop";
  version = "2.0.0";
  src = fetchFromGitLab {
    owner = "Matt.Jolly";
    repo = "sddm-eucalyptus-drop";
    rev = "v2.0.0";
    sha256 = "wq6V3UOHteT6CsHyc7+KqclRMgyDXjajcQrX/y+rkA0=";
  };

  buildInputs = [
    qt6.qtsvg
    qt6.qt5compat
  ];
  dontWrapQtApps = true;

  patches = [
    ./fix-colors.patch
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r * $out
    cp -r ${background_image} $out/Background.jpg
    rm -rf $out/Backgrounds
    substituteInPlace $out/theme.conf --replace "Background=\"Backgrounds/david-clode-seM6i8gJ7d0-unsplash.jpg\"" "Background=\"Background.jpg\""

    runHook postInstall
  '';
  meta = {
    description = "Eucalyptus Drop theme for SDDM";
    platforms = ["x86_64-linux"];
  };
}
