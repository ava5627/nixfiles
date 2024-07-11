{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.hardware.bluetooth;
in {
  options.modules.hardware.bluetooth = {
    enable = mkBool true "Bluetooth support";
  };
  config = mkIf cfg.enable {
    hardware.bluetooth = {
      enable = true;
      settings = {
        General = {
          Enable = "Source,Sink,Media,Socket";
        };
      };
    };
    services.blueman.enable = true;
    home.services.blueman-applet.enable = true;
  };
}
