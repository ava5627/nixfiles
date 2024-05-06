{pkgs, config, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];
  modules = {
    theme.active = "Tokyo Night";
    desktop = {
      qtile.enable = true;
      firefox.autoStart = false;
      discord.autoStart = false;
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
  users.users."minecraft" = {
    name = "minecraft";
    description = "Minecraft Server User";
    isNormalUser = true;
    home = "/home/minecraft";
    group = "users";
    uid = 2000;
  };
}
