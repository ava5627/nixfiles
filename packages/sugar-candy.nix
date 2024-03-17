{
  stdenv,
  fetchFromGitHub,
}:
stdenv.mkDerivation {
  name = "sugar-candy";
  src = fetchFromGitHub {
    owner = "Kangie";
    repo = "sddm-sugar-candy";
    rev = "v1.6";
    sha256 = "p2d7I0UBP63baW/q9MexYJQcqSmZ0L5rkwK3n66gmqM=";
  };
  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp -r * $out
    cp -r ${../config/camp_fire.jpg} $out/Background.jpg
    cat theme.conf | sed "s|Background=.*|background=\"Background.jpg\"|g" > $out/theme.conf
    runHook postInstall
  '';
  meta = {
    description = "Sugar Candy theme for SDDM";
    platforms = ["x86_64-linux"];
  };
}
