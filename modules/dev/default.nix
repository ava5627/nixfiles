{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev;
in {
  options.modules.dev.enable = mkBool true "Enable dev module";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      gnumake
      gcc
      alejandra # nix formatter
    ];
  };
}
