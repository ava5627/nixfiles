{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.transmission;
in {
  options.modules.services.transmission.enable = mkBool true "Transmission";
  config = mkIf cfg.enable {
    services.transmission = {
      enable = true;
      package = pkgs.transmission_4-gtk;
    };
  };
}
