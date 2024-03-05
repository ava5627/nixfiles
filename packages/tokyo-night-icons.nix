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
        rev = "2ce608528f79501a79fcfcf97a397ada733143f8";
        sha256 = "N77rSuEKe5tbMo28WJsnB98GUFS/VncAOiX3vPfCfW4=";
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

    meta = {
        description = "Tokyo night gtk icons";
        platforms = [ "x86_64-linux" ];
    };
}
