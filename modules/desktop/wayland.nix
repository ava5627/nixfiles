{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.wayland;
in {
  options.modules.desktop.wayland.enable = mkBool true "Wayland";
  config = mkIf cfg.enable {
    modules.desktop.rofi.wayland = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];
  };
}
