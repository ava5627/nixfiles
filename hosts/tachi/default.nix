{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];
  modules = {
    theme.active = "Tokyo Night";
    desktop = {
      hyprland.enable = true;
      qtile.enable = true;
      kdeconnect.enable = false;
      firefox.autoStart = false;
      discord.autoStart = false;
      gaming.steam.enable = true;
      gaming.steam.autoStart = false;
      gaming.minecraft.enable = true;
    };
    services.foundry.enable = true;
  };
  environment.systemPackages = [
    pkgs.my.msi-perkeyrgb
  ];
  services.udev.packages = [pkgs.my.msi-perkeyrgb];
}
