{
  config,
  lib,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.terminal.aliases;
in {
  options.modules.terminal.aliases.enable = mkBool true "Basic shell aliases";
  config = mkIf cfg.enable {
    home.home.shellAliases = {
      c = "clear";
      ll = "ls -l";
      la = "ls -A";
      lla = "ls -lA";
      ip = "ip -c";
      ipa = "ip addr";
      ".." = "cd ..";
      "..." = "cd ../..";
      "...." = "cd ../../..";
    };
  };
}
