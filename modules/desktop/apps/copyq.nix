{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.my; let
  cfg = config.modules.desktop.copyq;
in {
  options.modules.desktop.copyq.enable = mkBool true "CopyQ";
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      copyq
    ];
    modules.autoStart = [
      "copyq"
    ];
    home.xdg.configFile = {
      "copyq/" = {
        source = "${config.dotfiles.config}/copyq";
        recursive = true;
      };
    };
  };
}
