{
  python3,
  fetchFromGitHub,
  hidapi,
}:
with python3.pkgs;
  buildPythonPackage {
    # https://github.com/Askannz/msi-perkeyrgb
    pname = "msi-perkeyrgb";
    version = "2.1";
    src = fetchFromGitHub {
      owner = "Askannz";
      repo = "msi-perkeyrgb";
      rev = "e185a29e864bdda952b336940b047b5f97419d46";
      sha256 = "0f25png4fcf7n07g57aa8nc2z3524ydx41b1vzh4dyij39r8lvs0";
    };

    postInstall = ''
      mkdir -p $out/etc/udev/rules.d
      cp ./99-msi-rgb.rules $out/etc/udev/rules.d
    '';

    nativeBuildInputs = [hidapi setuptools];
    buildInputs = [hidapi];
    build-system = [setuptools];
  }
