{...}: {
  imports = [
    ./hardware-configuration.nix
  ];
  modules = {
    theme.active = "Tokyo Night";
    desktop = {
      gaming = {
        steam.enable = true;
        minecraft.enable = true;
      };
      qtile.enable = true;
    };
  };
  services.hardware.openrgb.enable = true;
  modules.autoStart = [
    "openrgb -p Off"
  ];
}
