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
      gaming.steam.autoStart = false;
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
