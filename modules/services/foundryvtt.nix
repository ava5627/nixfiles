{
  config,
  lib,
  inputs,
  system,
  pkgs,
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
    nixpkgs.config.allowUnfree = true;
    services.foundryvtt = {
      enable = true;
      package = (pkgs.callPackage "${inputs.foundry-vtt}/pkgs/foundryvtt" { }).overrideAttrs (old: old // {
        majorVersion = "14";
        releaseType = "stable";
      });
    };
    user.extraGroups = ["foundryvtt"];
  };
}
