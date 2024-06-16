{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.dev.latex;
in {
  options.modules.dev.latex.enable = mkEnableOption "LaTeX";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      texliveMedium
    ];
    programs.java.enable = true;
  };
}
