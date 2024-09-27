{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.kdeconnect;
in {
  options.modules.desktop.kdeconnect.enable = mkBool true "kdeconnect";
  config = mkIf cfg.enable {
    home.services.kdeconnect = {
      enable = true;
      indicator = true;
    };
    modules.autoStart = ["systemctl restart --user kdeconnect-indicator"];
  };
}
