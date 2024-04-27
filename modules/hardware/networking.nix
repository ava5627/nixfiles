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
      avahi.enable = true; # mDNS support
      printing.enable = true;
      openssh = {
        enable = true;
      };
    };
    networking.hosts = {
      "73.78.217.14" = ["ragnatus"];
      "71.56.222.98" = ["strahd"];
    };
  };
}
