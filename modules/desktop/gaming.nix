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
        pkgs.ckan
        pkgs.dotnet-sdk_8 # required for tModLoader to work
        pkgs.rimsort
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
      nixpkgs.overlays = [
        (final: prev: {
          vintagestory = prev.vintagestory.overrideAttrs (_: rec {
            version = "1.20.8";
            src = pkgs.fetchurl {
              url = "https://cdn.vintagestory.at/gamefiles/stable/vs_client_linux-x64_${version}.tar.gz";
              sha256 = "0zw4xl0fh5rjzb401k2bh6c8hrvjv2l0g10clqidxwsn99fmx0r0";
            };
          });
        })
      ];
      nixpkgs.config.permittedInsecurePackages = [
        "dotnet-runtime-wrapped-7.0.20" # for Vintagestory
        "dotnet-runtime-7.0.20" # for Vintagestory
      ];
      environment.systemPackages = with pkgs; [
        vintagestory
      ];
    })
  ];
}
