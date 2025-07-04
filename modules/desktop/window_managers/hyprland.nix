{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.hyprland;
in {
  options.modules.desktop.hyprland.enable = mkEnableOption "hyprland";
  config = mkIf cfg.enable {
    modules.desktop.wayland.enable = true;
    programs.hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };
    home = {
      # wayland.windowManager.hyprland = {
      #   enable = true;
      #   settings = {
      #   };
      # };
      services = {
        hyprpaper = {
          enable = true;
        };
      };
    };
    services.displayManager.sddm.wayland.enable = true;
    environment.systemPackages = with pkgs; [
      hyprpicker
    ];
  };
}
