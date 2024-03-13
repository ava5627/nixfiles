{...}: {
  imports = [
    ./hardware-configuration.nix
  ];
  modules.theme.active = "Tokyo Night";
  services.hardware.openrgb.enable = true;
}
