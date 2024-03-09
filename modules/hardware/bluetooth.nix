{
  config,
  lib,
  pkgs,
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
    hardware.bluetooth.enable = true;
    environment.systemPackages = with pkgs; [
      blueberry # graphical bluetooth manager
    ];
  };
}
