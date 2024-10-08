{
  stdenv,
  fetchFromGitHub,
  gtk-engine-murrine,
  gnome-themes-extra,
}:
stdenv.mkDerivation {
  pname = "tokyo-night-theme";
  version = "unstable-2024-02-29";

  src = fetchFromGitHub {
    owner = "ava5627";
    repo = "TokyoNightTheme";
    rev = "616cd1fe2a4f688b9798e3d0de4125168b67ba03";
    sha256 = "02bwqdax2bnya4fqf91wj7yl06skp1832v4mv53bjqxpqqwf49ww";
  };

  propagatedUserEnvPkgs = [
    gtk-engine-murrine
    gnome-themes-extra
  ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall
    mkdir -p $out/share/icons/Tokyonight/
    cp -r icons/* $out/share/icons/Tokyonight/
    mkdir -p $out/share/Kvantum/
    cp -r KvArcTokyoNight $out/share/Kvantum/
    runHook postInstall
  '';

  meta = {
    description = "Tokyo night icons and qt theme";
    platforms = ["x86_64-linux"];
  };
}
