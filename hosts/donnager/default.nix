{...}: {
  imports = [
    ./hardware-configuration.nix
  ];
  modules = {
    theme.active = "Tokyo Night";
    desktop = {
      gaming = {
        steam = true;
        minecraft = true;
      };
      qtile.enable = true;
    };
  };
  services.hardware.openrgb.enable = true;
}
