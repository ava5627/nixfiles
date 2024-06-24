{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.discord;
in {
  options.modules.desktop.discord = {
    enable = mkEnableOption "Discord";
    autoStart = mkBool true "Start Discord on login";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs;
      [
        discord
        betterdiscordctl
      ];

    modules.autoStart = mkIf cfg.autoStart [
      "discord"
    ];
  };
}
