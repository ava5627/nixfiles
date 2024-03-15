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
    networking.firewall.enable = false;
    services = {
      avahi.enable = true; # mDNS support
      printing.enable = true;
      openssh = {
        enable = true;
        settings.PermitRootLogin = "prohibit-password";
      };
    };
  };
}
