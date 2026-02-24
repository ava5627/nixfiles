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
    others.enable = mkEnableOption "Enable other gaming-related packages";
  };
  config = mkMerge [
    (mkIf cfg.steam.enable {
      # https://github.com/ValveSoftware/steam-for-linux/issues/1890#issuecomment-2367103614
      # consider bubblewraping steam as suggested above to move it out of home
      programs.steam.enable = true;
      environment.systemPackages = [
        pkgs.ckan # Kerbal Space Program mod manager
        pkgs.dotnet-sdk_8 # required for tModLoader to work
        pkgs.rimsort # RimWorld mod manager
        pkgs.steamcmd
        pkgs.owmods-gui # outer wilds mod manager
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
    (mkIf cfg.others.enable {
      environment.systemPackages = with pkgs; [
        vintagestory
      ];
    })
  ];
}
