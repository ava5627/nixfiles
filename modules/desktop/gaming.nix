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
    enable = mkEnableOption "Enable gaming";
    steam = mkBool true "gaming";
    minecraft = mkBool true "minecraft";
    wine = mkBool true "wine";
  };
  config = mkIf cfg.enable (mkMerge [
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
  ]);
}
