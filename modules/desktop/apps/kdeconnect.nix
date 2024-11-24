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
    # the indicator doesn't start on login so we need to restart it
    # this is because there is no systemd target for after qtile's systray is started
    modules.autoStart = ["systemctl restart --user kdeconnect-indicator"];
  };
}
