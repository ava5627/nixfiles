{
  config,
  lib,
  inputs,
  system,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.services.foundry;
in {
  imports = [
    inputs.foundry-vtt.nixosModules.foundryvtt
  ];
  options.modules.services.foundry.enable = mkEnableOption "Enable Foundry VTT";
  config = mkIf cfg.enable {
    services.foundryvtt = {
      enable = true;
      package = inputs.foundry-vtt.packages.${system}.foundryvtt_latest;
    };
    user.extraGroups = ["foundryvtt"];
  };
}
