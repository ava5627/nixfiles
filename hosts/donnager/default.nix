{pkgs, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];
  modules = {
    theme.active = "Catppuccin";
    desktop = {
      gaming = {
        steam.enable = true;
        minecraft.enable = true;
        lutris.enable = true;
      };
      qtile.enable = true;
    };
    dev.latex.enable = true;
    services = {
      audiobookshelf.enable = true;
    };
  };
  services.hardware.openrgb.enable = true;
  modules.autoStart = ["openrgb -p Off"];
  environment.systemPackages = [
    pkgs.my.vscode-factoriomod-debug
  ];
}
