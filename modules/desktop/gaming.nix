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
  options.modules.desktop.gaming.enable = mkBool true "gaming";
  config = mkIf cfg.enable {
    programs.steam.enable = true;
    environment.systemPackages = with pkgs; [
      jdk17 # java 17
      jdk8 # java 8
      prismlauncher
      ckan
    ];
  };
}
