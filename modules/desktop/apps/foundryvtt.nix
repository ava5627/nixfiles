{
  config,
  lib,
  inputs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.foundry;
in {
  imports = [
    inputs.foundry-vtt.nixosModules.foundryvtt
  ];
  options.modules.desktop.foundry.enable = mkEnableOption "Enable Foundry VTT";
  config = mkIf cfg.enable {
    services.foundryvtt = {
      enable = true;
    };
    user.extraGroups = [ "foundryvtt" ];
  };
}
