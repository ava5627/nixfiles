{
  stdenv,
  fetchFromGitLab,
  qtquickcontrols2, # required for sddm theme
  qtgraphicaleffects, # required for sddm theme
  background_image ? ../config/camp_fire.jpg
}:
stdenv.mkDerivation {
  name = "eucalyptus-drop";
  version = "0.0.1";
  src = fetchFromGitLab {
    owner = "Matt.Jolly";
    repo = "sddm-eucalyptus-drop";
    rev = "v2.0.0";
    sha256 = "u45nqtJRi/FabSYHDWIt4vG32xUDt2mxy4TTUez5+J8=";
  };

  propagatedBuildInputs = [
    qtquickcontrols2
    qtgraphicaleffects
  ];

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
