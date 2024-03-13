{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.terminal.ranger;
in {
  options.modules.terminal.ranger.enable = mkBool false "Ranger";
  config = mkIf cfg.enable {
    home.programs.ranger = {
      enable = true;
      aliases = {
        search = "scout -lstfpe";
      };
      mappings = {
        f = "console scout -ftsea%space";
      };
    };
  };
}
