{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.terminal.direnv;
in {
  options.modules.terminal.direnv.enable = mkBool true "direnv";
  config = mkIf cfg.enable {
    home.programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
  };
}
