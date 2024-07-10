{
  stdenv,
  fetchFromGitLab,
  libsForQt5,
  background_image ? ../config/camp_fire.jpg
}:
stdenv.mkDerivation {
  name = "eucalyptus-drop";
  version = "0.0.1";
  src = fetchFromGitLab {
    owner = "Matt.Jolly";
    repo = "sddm-eucalyptus-drop";
    rev = "v2.0.0";
    sha256 = "wq6V3UOHteT6CsHyc7+KqclRMgyDXjajcQrX/y+rkA0=";
  };

  propagatedBuildInputs = [
      libsForQt5.qt5.qtquickcontrols2 # required for sddm theme
      libsForQt5.qt5.qtgraphicaleffects # required for sddm theme
  ];

  dontWrapQtApps = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r * $out
    cp -r ${background_image} $out/Background.jpg
    cat theme.conf | sed "s|Background=.*|background=\"Background.jpg\"|g" > $out/theme.conf
    runHook postInstall
  '';
  meta = {
    description = "Eucalyptus Drop theme for SDDM";
    platforms = ["x86_64-linux"];
  };
}
