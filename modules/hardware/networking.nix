{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.networking;
in {
  options.modules.hardware.networking.enable = mkBool true "Networking";
  config = mkIf cfg.enable {
    networking.networkmanager.enable = true;
    programs.nm-applet.enable = config.services.xserver.enable;
    networking.firewall.enable = false;
    services = {
      resolved.enable = true;
      printing.enable = true;
      openssh = {
        enable = true;
      };
    };
  };
}
