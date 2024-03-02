{ pkgs}:
let
    background-url = "https://i.imgur.com/vIhhHau.jpeg";
    image = pkgs.fetchurl {
        url = background-url;
        sha256 = "wPxpbdO/LWECYJWUJ+GM+HXTxyj2uNEaZ9piXuoAJJk=";
    };
in
pkgs.stdenv.mkDerivation {
    name = "sugar-candy";
    src = pkgs.fetchFromGitHub {
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
        cat $out/theme.conf | sed "s|ScreenWidth=.*|ScreenWidth=1920|g" > $out/theme.conf
        cat $out/theme.conf | sed "s|ScreenHeight=.*|ScreenHeight=1080|g" > $out/theme.conf
    '';
}
