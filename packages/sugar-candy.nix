{
  stdenv,
  fetchFromGitHub,
  fetchurl,
}: let
  background-url = "https://i.imgur.com/vIhhHau.jpeg";
  image = fetchurl {
    url = background-url;
    sha256 = "wPxpbdO/LWECYJWUJ+GM+HXTxyj2uNEaZ9piXuoAJJk=";
  };
in
  stdenv.mkDerivation {
    name = "sugar-candy";
    src = fetchFromGitHub {
      owner = "Kangie";
      repo = "sddm-sugar-candy";
      rev = "v1.6";
      sha256 = "p2d7I0UBP63baW/q9MexYJQcqSmZ0L5rkwK3n66gmqM=";
    };
    installPhase = ''
      mkdir -p $out
      cp -r * $out
      cp -r ${image} $out/Background.jpg
      cat theme.conf | sed "s|Background=.*|background=\"Background.jpg\"|g" > $out/theme.conf
    '';
    meta = {
      description = "Sugar Candy theme for SDDM";
      platforms = ["x86_64-linux"];
    };
  }
