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
    steam.enable = mkEnableOption "steam";
    steam.autoStart = mkBool true "Start Steam on login";
    minecraft.enable = mkEnableOption "minecraft";
    wine.enable = mkEnableOption "wine";
    lutris.enable = mkEnableOption "lutris";
  };
  config = mkMerge [
    (mkIf cfg.steam.enable {
      programs.steam.enable = true;
      environment.systemPackages = [
        pkgs.ckan
      ];
      modules.autoStart = mkIf cfg.steam.autoStart [
        "steam -silent"
      ];
    })
    (mkIf cfg.minecraft.enable {
      environment.systemPackages = [
        pkgs.jdk17
        pkgs.jdk8
        pkgs.prismlauncher
      ];
    })
    (mkIf cfg.wine.enable {
      environment.systemPackages = [
        pkgs.wine
      ];
      environment.variables = {
        WINEPREFIX = "$XDG_DATA_HOME/wine";
        WINEARCH = "win64";
      };
    })
    (mkIf cfg.lutris.enable {
      environment.systemPackages = [
        pkgs.lutris
      ];
    })
  ];
}
