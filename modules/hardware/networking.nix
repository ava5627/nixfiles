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
      # avahi = {
      #   enable = true; # mDNS support
      #   nssmdns4 = true;
      #   publish = {
      #     enable = true;
      #     domain = true;
      #     addresses = true;
      #   };
      # };
      printing.enable = true;
      openssh = {
        enable = true;
      };
    };
  };
}
