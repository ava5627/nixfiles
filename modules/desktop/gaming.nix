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
    others.enable = mkBool cfg.steam.enable "Enable other gaming-related packages";
  };
  config = mkMerge [
    (mkIf cfg.steam.enable {
      # https://github.com/ValveSoftware/steam-for-linux/issues/1890#issuecomment-2367103614
      # consider bubblewraping steam as suggested above to move it out of home
      programs.steam.enable = true;
      environment.systemPackages = [
        pkgs.ckan
        pkgs.dotnet-sdk_8 # required for tModLoader to work
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
        my.vintagestory
      ];
      nixpkgs.config.permittedInsecurePackages = [
        "dotnet-runtime-wrapped-7.0.20" # for Vintagestory
        "dotnet-runtime-7.0.20" # for Vintagestory
      ];
    })
  ];
}
