{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];
  modules = {
    theme.active = "Tokyo Night";
    desktop = {
      qtile.enable = true;
      firefox.autoStart = false;
      discord.autoStart = false;
      morgen.autoStart = false;
      kdeconnect.autoStart = false;
      gaming.steam.enable = true;
      gaming.steam.autoStart = false;
      gaming.minecraft.enable = true;
      foundry.enable = true;
    };
  };
  services.xserver.libinput = {
    enable = true;
    touchpad.naturalScrolling = true;
  };
  environment.systemPackages = [
    pkgs.my.msi-perkeyrgb
  ];
  services.udev.packages = [pkgs.my.msi-perkeyrgb];
}
