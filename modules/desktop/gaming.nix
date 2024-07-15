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
    lutris.enable = mkEnableOption "lutris";
  };
  config = mkMerge [
    (mkIf cfg.steam.enable {
      programs.steam.enable = true;
      environment.systemPackages = [
        pkgs.ckan
        pkgs.dotnet-sdk
      ];
      modules.autoStart = mkIf cfg.steam.autoStart [
        "steam -silent"
      ];
    })
    (mkIf cfg.minecraft.enable {
      environment.systemPackages = [
        pkgs.prismlauncher
      ];
    })
    (mkIf cfg.lutris.enable {
      environment.systemPackages = [
        pkgs.lutris
      ];
    })
  ];
}
