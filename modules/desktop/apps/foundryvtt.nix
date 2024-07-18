{
  config,
  lib,
  inputs,
  pkgs,
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
      package = inputs.foundry-vtt.packages.${pkgs.system}.foundryvtt_12;
    };
    user.extraGroups = [ "foundryvtt" ];
  };
}
