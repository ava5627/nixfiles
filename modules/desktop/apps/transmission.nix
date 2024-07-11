{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.transmission;
in {
  options.modules.desktop.transmission.enable = mkBool true "Transmission";
  config = mkIf cfg.enable {
    services.transmission = {
      enable = true;
      package = pkgs.transmission_4-gtk;
    };
  };
}
