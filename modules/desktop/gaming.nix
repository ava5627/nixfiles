{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.gaming;
in {
  options.modules.desktop.gaming = {
    steam = mkEnableOption "steam";
    minecraft = mkEnableOption "minecraft";
    wine = mkEnableOption "wine";
    lutris = mkEnableOption "lutris";
  };
  config = mkMerge [
    (mkIf cfg.steam {
      programs.steam.enable = true;
      environment.systemPackages = [
        pkgs.ckan
      ];
    })
    (mkIf cfg.minecraft {
      environment.systemPackages = [
        pkgs.jdk17
        pkgs.jdk8
        pkgs.prismlauncher
      ];
    })
    (mkIf cfg.wine {
      environment.systemPackages = [
        pkgs.wine
      ];
      environment.variables = {
        WINEPREFIX = "$XDG_DATA_HOME/wine";
        WINEARCH = "win64";
      };
    })
    (mkIf cfg.lutris {
      environment.systemPackages = [
        pkgs.lutris
      ];
    })
  ];
}
